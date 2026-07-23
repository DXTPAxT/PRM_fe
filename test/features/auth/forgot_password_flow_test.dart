import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:clothing_store_app/core/storage/secure_storage.dart';
import 'package:clothing_store_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:clothing_store_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clothing_store_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:clothing_store_app/features/auth/presentation/screens/login_screen.dart';
import 'package:clothing_store_app/features/auth/presentation/screens/reset_password_screen.dart';

class _FakeSecureStorage implements SecureStorage {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.forgotPasswordError, this.resetPasswordError});

  final Object? forgotPasswordError;
  final Object? resetPasswordError;
  int forgotPasswordCalls = 0;
  int resetPasswordCalls = 0;

  @override
  Future<void> forgotPassword({required String email}) async {
    forgotPasswordCalls++;
    if (forgotPasswordError case final error?) throw error;
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    resetPasswordCalls++;
    if (resetPasswordError case final error?) throw error;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GoRouter _router({required String initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (_, __) => const ResetPasswordScreen(),
      ),
    ],
  );
}

Widget _app({required AuthRepository repository, required GoRouter router}) {
  return ProviderScope(
    overrides: [
      secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
      authRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  const successMessage =
      'OTP đã được gửi nếu thông tin tồn tại. Vui lòng kiểm tra email.';

  testWidgets(
    'forgot password shows one green message even with login below it',
    (tester) async {
      final repository = _FakeAuthRepository();
      final router = _router(initialLocation: '/login');
      addTearDown(router.dispose);

      await tester.pumpWidget(_app(repository: repository, router: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Quên mật khẩu?'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField),
        'customer1@clothing.dev',
      );
      await tester.tap(find.text('Gửi mã OTP'));
      await tester.pump();
      // Let the route transition finish. During the transition Flutter's
      // SnackBar hero temporarily exists in both the outgoing and incoming
      // routes with the same key.
      await tester.pump(const Duration(seconds: 1));

      expect(repository.forgotPasswordCalls, 1);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(successMessage), findsOneWidget);
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        Colors.green,
      );
      expect(find.byType(ResetPasswordScreen), findsOneWidget);
    },
  );

  testWidgets('forgot password error is shown once and remains on the form', (
    tester,
  ) async {
    final repository = _FakeAuthRepository(
      forgotPasswordError: Exception('Không thể gửi OTP'),
    );
    final router = _router(initialLocation: '/forgot-password');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(repository: repository, router: router));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField),
      'customer1@clothing.dev',
    );
    await tester.tap(find.text('Gửi mã OTP'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(repository.forgotPasswordCalls, 1);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Không thể gửi OTP'), findsOneWidget);
    expect(find.textContaining('Exception:'), findsNothing);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      Colors.red,
    );
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
  });

  testWidgets('reset password success shows one green message', (tester) async {
    final repository = _FakeAuthRepository();
    final router = _router(initialLocation: '/reset-password');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(repository: repository, router: router));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'customer1@clothing.dev');
    await tester.enterText(fields.at(1), '123456');
    await tester.enterText(fields.at(2), 'NewPassword@123');
    await tester.tap(find.text('Cập nhật mật khẩu'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(repository.resetPasswordCalls, 1);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text('Đổi mật khẩu thành công. Vui lòng đăng nhập.'),
      findsOneWidget,
    );
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      Colors.green,
    );
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('reset password rejects a password without an uppercase letter', (
    tester,
  ) async {
    final repository = _FakeAuthRepository();
    final router = _router(initialLocation: '/reset-password');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(repository: repository, router: router));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'customer1@clothing.dev');
    await tester.enterText(fields.at(1), '123456');
    await tester.enterText(fields.at(2), 'password1!');
    await tester.tap(find.text('Cập nhật mật khẩu'));
    await tester.pump();

    expect(repository.resetPasswordCalls, 0);
    expect(find.text('Mật khẩu phải có ít nhất 1 chữ hoa'), findsOneWidget);
    expect(find.byType(ResetPasswordScreen), findsOneWidget);
  });
}
