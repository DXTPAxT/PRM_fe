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
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../data/models/otp_models.dart';

enum AuthStatus { initial, unauthenticated, authenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isLoading;
  final String? pendingIdentifier;
  final RegisterChallenge? otpChallenge;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.isLoading = false,
    this.pendingIdentifier,
    this.otpChallenge,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
  factory AuthState.unauthenticated({
    String? error,
    String? pendingIdentifier,
    RegisterChallenge? otpChallenge,
    bool isLoading = false,
  }) => AuthState(
    status: AuthStatus.unauthenticated,
    errorMessage: error,
    pendingIdentifier: pendingIdentifier,
    otpChallenge: otpChallenge,
    isLoading: isLoading,
  );
  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);
  factory AuthState.loading({
    String? pendingIdentifier,
    RegisterChallenge? otpChallenge,
  }) => AuthState.unauthenticated(
    pendingIdentifier: pendingIdentifier,
    otpChallenge: otpChallenge,
    isLoading: true,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorage _secureStorage;
  final Ref _ref;

  AuthNotifier({required SecureStorage secureStorage, required Ref ref})
    : _secureStorage = secureStorage,
      _ref = ref,
      super(AuthState.initial()) {
    checkInitialState();
  }

  Future<void> checkInitialState() async {
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      try {
        final user = await _ref.read(getCurrentUserUseCaseProvider).call();
        state = AuthState.authenticated(user);
      } catch (_) {
        await _secureStorage.clearTokens();
        state = AuthState.unauthenticated();
      }
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
      final challenge = await registerUseCase(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      state = AuthState.unauthenticated(
        error: 'Mã OTP đã được gửi. Vui lòng xác thực tài khoản.',
        pendingIdentifier: challenge.identifier,
        otpChallenge: challenge,
      );
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final challenge = state.otpChallenge;
    state = AuthState.loading(
      pendingIdentifier: email,
      otpChallenge: challenge,
    );
    try {
      final verifyOtpUseCase = _ref.read(verifyOtpUseCaseProvider);
      final response = await verifyOtpUseCase(email: email, otp: otp);
      await _secureStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      state = AuthState.authenticated(response.user);
    } catch (e) {
      state = AuthState.unauthenticated(
        error: e.toString(),
        pendingIdentifier: email,
        otpChallenge: challenge,
      );
    }
  }

  Future<void> resendOtp(String identifier) async {
    final challenge = state.otpChallenge;
    state = AuthState.loading(
      pendingIdentifier: identifier,
      otpChallenge: challenge,
    );
    try {
      final nextChallenge = await _ref
          .read(resendOtpUseCaseProvider)
          .call(identifier: identifier);
      state = AuthState.unauthenticated(
        error: 'OTP mới đã được gửi.',
        pendingIdentifier: nextChallenge.identifier,
        otpChallenge: nextChallenge,
      );
    } catch (e) {
      state = AuthState.unauthenticated(
        error: e.toString(),
        pendingIdentifier: identifier,
        otpChallenge: challenge,
      );
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

  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    state = AuthState.loading();
    try {
      final resetPasswordUseCase = _ref.read(resetPasswordUseCaseProvider);
      await resetPasswordUseCase(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      state = AuthState.unauthenticated(
        error: 'Đổi mật khẩu thành công. Vui lòng đăng nhập.',
      );
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> setAuthenticatedUser(
    User user,
    String accessToken,
    String refreshToken,
  ) async {
    await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
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

final resendOtpUseCaseProvider = Provider<ResendOtpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResendOtpUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthNotifier(secureStorage: secureStorage, ref: ref);
});
