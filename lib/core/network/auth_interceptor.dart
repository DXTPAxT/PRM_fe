import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../storage/hive_cache.dart';

class AuthInterceptor extends QueuedInterceptor {
  final SecureStorage _secureStorage;
  final Dio _refreshDio;
  final void Function()? _onLogout;
  final Future<void> Function() _clearCache;

  AuthInterceptor({
    required SecureStorage secureStorage,
    required Dio refreshDio,
    void Function()? onLogout,
    Future<void> Function()? clearCache,
  }) : _secureStorage = secureStorage,
       _refreshDio = refreshDio,
       _onLogout = onLogout,
       _clearCache = clearCache ?? HiveCache.clearAll;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !_isAuthEndpoint(err.requestOptions.path)) {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        String? newAccessToken;
        try {
          final response = await _refreshDio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final responseData = response.data;
            final data = responseData is Map ? responseData['data'] : null;
            final tokenData = data is Map
                ? data
                : responseData is Map
                ? responseData
                : const <String, dynamic>{};
            final accessToken = tokenData['accessToken'];
            final newRefreshToken = tokenData['refreshToken'];

            if (accessToken is String &&
                accessToken.isNotEmpty &&
                newRefreshToken is String &&
                newRefreshToken.isNotEmpty) {
              newAccessToken = accessToken;
              await _secureStorage.saveAccessToken(accessToken);
              await _secureStorage.saveRefreshToken(newRefreshToken);
            }
          }
        } catch (_) {
          await _clearSession();
          return super.onError(err, handler);
        }

        if (newAccessToken != null) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final responseClone = await _refreshDio.fetch(options);
            return handler.resolve(responseClone);
          } on DioException catch (retryError) {
            // Refresh succeeded, so this is an application/request error.
            // Preserve the authenticated session and surface it to the caller.
            return handler.reject(retryError);
          } catch (_) {
            return super.onError(err, handler);
          }
        }
      }

      // Missing or malformed refresh credentials mean the session is no longer
      // recoverable.
      await _clearSession();
    }

    super.onError(err, handler);
  }

  Future<void> _clearSession() async {
    await _secureStorage.clearTokens();
    await _clearCache();
    _onLogout?.call();
  }

  bool _isAuthEndpoint(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return normalizedPath == '/auth/login' ||
        normalizedPath == '/auth/refresh' ||
        normalizedPath == '/auth/logout';
  }
}
