import 'dart:async';

import 'package:clothing_store_app/core/network/auth_interceptor.dart';
import 'package:clothing_store_app/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthInterceptor', () {
    test(
      'propagates a business 401 after refresh without clearing the session',
      () async {
        final storage = _FakeSecureStorage(
          accessToken: 'expired-access-token',
          refreshToken: 'valid-refresh-token',
        );
        final requests = <RequestOptions>[];
        var cacheClearCalls = 0;
        var logoutCalls = 0;
        final refreshDio = _stubDio((options, handler) {
          requests.add(options);
          if (options.path == '/auth/refresh') {
            handler.resolve(_refreshSuccess(options));
            return;
          }

          final response = Response<dynamic>(
            requestOptions: options,
            statusCode: 401,
            data: {'message': 'Mật khẩu hiện tại không chính xác'},
          );
          handler.reject(
            DioException.badResponse(
              statusCode: 401,
              requestOptions: options,
              response: response,
            ),
          );
        });
        final interceptor = AuthInterceptor(
          secureStorage: storage,
          refreshDio: refreshDio,
          clearCache: () async => cacheClearCalls++,
          onLogout: () => logoutCalls++,
        );

        final outcome = await _runInterceptor(
          interceptor,
          _originalUnauthorizedError(),
        );

        expect(outcome.type, _OutcomeType.reject);
        final retryError = outcome.value as DioException;
        expect(retryError.response?.statusCode, 401);
        expect(retryError.response?.data, {
          'message': 'Mật khẩu hiện tại không chính xác',
        });
        expect(storage.accessToken, 'fresh-access-token');
        expect(storage.refreshToken, 'fresh-refresh-token');
        expect(storage.clearTokensCalls, 0);
        expect(cacheClearCalls, 0);
        expect(logoutCalls, 0);
        expect(requests, hasLength(2));
        expect(
          requests.last.headers['Authorization'],
          'Bearer fresh-access-token',
        );
      },
    );

    test('clears the session when the refresh request fails', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'expired-access-token',
        refreshToken: 'invalid-refresh-token',
      );
      var cacheClearCalls = 0;
      var logoutCalls = 0;
      final refreshDio = _stubDio((options, handler) {
        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: 401,
          data: {'message': 'Refresh token không hợp lệ'},
        );
        handler.reject(
          DioException.badResponse(
            statusCode: 401,
            requestOptions: options,
            response: response,
          ),
        );
      });
      final originalError = _originalUnauthorizedError();
      final interceptor = AuthInterceptor(
        secureStorage: storage,
        refreshDio: refreshDio,
        clearCache: () async => cacheClearCalls++,
        onLogout: () => logoutCalls++,
      );

      final outcome = await _runInterceptor(interceptor, originalError);

      expect(outcome.type, _OutcomeType.next);
      expect(outcome.value, same(originalError));
      expect(storage.accessToken, isNull);
      expect(storage.refreshToken, isNull);
      expect(storage.clearTokensCalls, 1);
      expect(cacheClearCalls, 1);
      expect(logoutCalls, 1);
    });

    test(
      'clears the session when the rotated token pair is malformed',
      () async {
        final storage = _FakeSecureStorage(
          accessToken: 'expired-access-token',
          refreshToken: 'valid-refresh-token',
        );
        var cacheClearCalls = 0;
        var logoutCalls = 0;
        final refreshDio = _stubDio((options, handler) {
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'data': {'accessToken': 'fresh-access-token'},
              },
            ),
          );
        });
        final originalError = _originalUnauthorizedError();
        final interceptor = AuthInterceptor(
          secureStorage: storage,
          refreshDio: refreshDio,
          clearCache: () async => cacheClearCalls++,
          onLogout: () => logoutCalls++,
        );

        final outcome = await _runInterceptor(interceptor, originalError);

        expect(outcome.type, _OutcomeType.next);
        expect(outcome.value, same(originalError));
        expect(storage.accessToken, isNull);
        expect(storage.refreshToken, isNull);
        expect(storage.clearTokensCalls, 1);
        expect(cacheClearCalls, 1);
        expect(logoutCalls, 1);
      },
    );

    test('stores rotated tokens and resolves a successful retry', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'expired-access-token',
        refreshToken: 'valid-refresh-token',
      );
      final requests = <RequestOptions>[];
      var cacheClearCalls = 0;
      var logoutCalls = 0;
      final refreshDio = _stubDio((options, handler) {
        requests.add(options);
        if (options.path == '/auth/refresh') {
          handler.resolve(_refreshSuccess(options));
          return;
        }

        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: {'success': true},
          ),
        );
      });
      final interceptor = AuthInterceptor(
        secureStorage: storage,
        refreshDio: refreshDio,
        clearCache: () async => cacheClearCalls++,
        onLogout: () => logoutCalls++,
      );

      final outcome = await _runInterceptor(
        interceptor,
        _originalUnauthorizedError(),
      );

      expect(outcome.type, _OutcomeType.resolve);
      final response = outcome.value as Response;
      expect(response.statusCode, 200);
      expect(response.data, {'success': true});
      expect(storage.accessToken, 'fresh-access-token');
      expect(storage.refreshToken, 'fresh-refresh-token');
      expect(storage.clearTokensCalls, 0);
      expect(cacheClearCalls, 0);
      expect(logoutCalls, 0);
      expect(requests, hasLength(2));
      expect(requests.last.method, 'PATCH');
      expect(requests.last.data, {
        'currentPassword': 'wrong-password',
        'newPassword': 'NewPassword1!',
      });
    });
  });
}

Dio _stubDio(
  void Function(RequestOptions, RequestInterceptorHandler) onRequest,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest));
  return dio;
}

Response<dynamic> _refreshSuccess(RequestOptions options) {
  return Response<dynamic>(
    requestOptions: options,
    statusCode: 200,
    data: {
      'data': {
        'accessToken': 'fresh-access-token',
        'refreshToken': 'fresh-refresh-token',
      },
    },
  );
}

DioException _originalUnauthorizedError() {
  final options = RequestOptions(
    baseUrl: 'https://api.example.test',
    path: '/users/me/password',
    method: 'PATCH',
    headers: {'Authorization': 'Bearer expired-access-token'},
    data: {'currentPassword': 'wrong-password', 'newPassword': 'NewPassword1!'},
  );
  final response = Response<dynamic>(
    requestOptions: options,
    statusCode: 401,
    data: {'message': 'Unauthorized'},
  );
  return DioException.badResponse(
    statusCode: 401,
    requestOptions: options,
    response: response,
  );
}

Future<_HandlerOutcome> _runInterceptor(
  AuthInterceptor interceptor,
  DioException error,
) {
  final handler = _RecordingErrorHandler();
  interceptor.onError(error, handler);
  return handler.result.timeout(const Duration(seconds: 2));
}

enum _OutcomeType { next, resolve, reject }

class _HandlerOutcome {
  const _HandlerOutcome(this.type, this.value);

  final _OutcomeType type;
  final Object value;
}

class _RecordingErrorHandler extends ErrorInterceptorHandler {
  final Completer<_HandlerOutcome> _completer = Completer<_HandlerOutcome>();

  Future<_HandlerOutcome> get result => _completer.future;

  @override
  void next(DioException error) {
    _completer.complete(_HandlerOutcome(_OutcomeType.next, error));
  }

  @override
  void resolve(Response response) {
    _completer.complete(_HandlerOutcome(_OutcomeType.resolve, response));
  }

  @override
  void reject(
    DioException error, [
    bool callFollowingErrorInterceptor = false,
  ]) {
    _completer.complete(_HandlerOutcome(_OutcomeType.reject, error));
  }
}

class _FakeSecureStorage extends SecureStorage {
  _FakeSecureStorage({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;
  int clearTokensCalls = 0;

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> saveAccessToken(String token) async {
    accessToken = token;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    refreshToken = token;
  }

  @override
  Future<void> clearTokens() async {
    clearTokensCalls++;
    accessToken = null;
    refreshToken = null;
  }
}
