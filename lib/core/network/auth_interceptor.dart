import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../storage/hive_cache.dart';

class AuthInterceptor extends QueuedInterceptor {
  final SecureStorage _secureStorage;
  final Dio _refreshDio;
  final void Function()? _onLogout;

  AuthInterceptor({
    required SecureStorage secureStorage,
    required Dio refreshDio,
    void Function()? onLogout,
  }) : _secureStorage = secureStorage,
       _refreshDio = refreshDio,
       _onLogout = onLogout;

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
        try {
          // Perform refresh token request
          // Note: [Backend Contract Required]
          // The actual refresh URL and body parameters must match the backend specification.
          // Example placeholder: POST /auth/refresh with body parameters.
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
            final newAccessToken = tokenData['accessToken'];
            final newRefreshToken = tokenData['refreshToken'];

            if (newAccessToken != null) {
              await _secureStorage.saveAccessToken(newAccessToken);
              if (newRefreshToken != null) {
                await _secureStorage.saveRefreshToken(newRefreshToken);
              }

              // Retry original request with updated authorization header
              final options = err.requestOptions;
              options.headers['Authorization'] = 'Bearer $newAccessToken';

              final cloneDio = Dio(
                BaseOptions(
                  baseUrl: options.baseUrl,
                  headers: options.headers,
                  connectTimeout: options.connectTimeout,
                  receiveTimeout: options.receiveTimeout,
                ),
              );

              final responseClone = await cloneDio.request(
                options.path,
                data: options.data,
                queryParameters: options.queryParameters,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
              );

              return handler.resolve(responseClone);
            }
          }
        } catch (_) {
          // Refresh flow failed or timed out
        }
      }

      // If no refresh token or refresh failed, perform logout
      await _secureStorage.clearTokens();
      await HiveCache.clearAll();
      _onLogout?.call();
    }

    super.onError(err, handler);
  }

  bool _isAuthEndpoint(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return normalizedPath == '/auth/login' ||
        normalizedPath == '/auth/refresh' ||
        normalizedPath == '/auth/logout';
  }
}
