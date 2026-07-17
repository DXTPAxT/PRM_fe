import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/hive_cache.dart';
import '../../../../core/network/dio_client.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
  factory AuthState.unauthenticated({String? error}) =>
      AuthState(status: AuthStatus.unauthenticated, errorMessage: error);
  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);
  factory AuthState.loading() => const AuthState(status: AuthStatus.initial, isLoading: true);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorage _secureStorage;
  final Ref _ref;

  AuthNotifier({
    required SecureStorage secureStorage,
    required Ref ref,
  })  : _secureStorage = secureStorage,
        _ref = ref,
        super(AuthState.initial()) {
    checkInitialState();
  }

  Future<void> checkInitialState() async {
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      // Default placeholder user for initialization (in real app, fetch profile API)
      state = AuthState.authenticated(
        const User(
          id: '1',
          fullName: 'User Scaffold',
          email: 'user@example.com',
          phone: '0123456789',
          role: 'customer',
        ),
      );
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      final loginUseCase = _ref.read(loginUseCaseProvider);
      final response = await loginUseCase(email: email, password: password);
      
      await _secureStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      state = AuthState.authenticated(response.user);
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = AuthState.loading();
    try {
      final registerUseCase = _ref.read(registerUseCaseProvider);
      await registerUseCase(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      state = AuthState.unauthenticated(error: 'Đăng ký thành công. Vui lòng đăng nhập.');
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    state = AuthState.loading();
    try {
      final verifyOtpUseCase = _ref.read(verifyOtpUseCaseProvider);
      await verifyOtpUseCase(email: email, otp: otp);
      state = AuthState.unauthenticated(error: 'Xác thực thành công. Bạn có thể đặt lại mật khẩu.');
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    state = AuthState.loading();
    try {
      final forgotPasswordUseCase = _ref.read(forgotPasswordUseCaseProvider);
      await forgotPasswordUseCase(email: email);
      state = AuthState.unauthenticated(error: 'Mã OTP đã gửi về email.');
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    state = AuthState.loading();
    try {
      final resetPasswordUseCase = _ref.read(resetPasswordUseCaseProvider);
      await resetPasswordUseCase(email: email, otp: otp, newPassword: newPassword);
      state = AuthState.unauthenticated(error: 'Đổi mật khẩu thành công. Vui lòng đăng nhập.');
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> setAuthenticatedUser(User user, String accessToken, String refreshToken) async {
    await _secureStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    state = AuthState.authenticated(user);
  }

  Future<void> logout() async {
    await _secureStorage.clearTokens();
    await HiveCache.clearAll();
    state = AuthState.unauthenticated();
  }
}

// Secure Storage Provider
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

// Dio Client Provider
final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return DioClient(
    secureStorage: secureStorage,
    onLogout: () {
      ref.read(authProvider.notifier).logout();
    },
  );
});

// Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDataSource(dioClient);
});

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// Usecase Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyOtpUseCase(repository);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPasswordUseCase(repository);
});

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthNotifier(secureStorage: secureStorage, ref: ref);
});
