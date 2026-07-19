import '../../../../shared/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_models.dart';
import '../models/otp_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> getCurrentUser() async {
    final response = await _remoteDataSource.getCurrentUser();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải thông tin tài khoản.');
  }

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      LoginRequest(email: email, password: password),
    );
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Đăng nhập thất bại.');
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    final response = await _remoteDataSource.logout(refreshToken);
    if (!response.success) {
      throw Exception(response.message ?? 'Đăng xuất thất bại.');
    }
  }

  @override
  Future<RegisterChallenge> register({
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
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Đăng ký thất bại.');
  }

  @override
  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _remoteDataSource.verifyOtp(
      VerifyOtpRequest(email: email, otp: otp),
    );
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Xác thực OTP thất bại.');
  }

  @override
  Future<RegisterChallenge> resendOtp({required String identifier}) async {
    final response = await _remoteDataSource.resendOtp(identifier);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Gửi lại OTP thất bại.');
  }

  @override
  Future<void> verifyOtpForPassword({
    required String email,
    required String otp,
  }) async {
    final response = await _remoteDataSource.verifyForgotPasswordOtp(
      VerifyOtpRequest(email: email, otp: otp),
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Xác thực OTP thất bại.');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
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
      ResetPasswordRequest(email: email, otp: otp, newPassword: newPassword),
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Đặt lại mật khẩu thất bại.');
    }
  }
}
