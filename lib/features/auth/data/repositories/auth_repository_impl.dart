import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      LoginRequest(email: email, password: password),
    );
    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Đăng nhập thất bại.');
    }
  }

  @override
  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await _remoteDataSource.register(
      RegisterRequest(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      ),
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Đăng ký thất bại.');
    }
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _remoteDataSource.verifyOtp(
      VerifyOtpRequest(email: email, otp: otp),
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Xác thực OTP thất bại.');
    }
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    final response = await _remoteDataSource.forgotPassword(
      ForgotPasswordRequest(email: email),
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Yêu cầu gửi OTP thất bại.');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await _remoteDataSource.resetPassword(
      ResetPasswordRequest(
        email: email,
        otp: otp,
        newPassword: newPassword,
      ),
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Đặt lại mật khẩu thất bại.');
    }
  }
}
