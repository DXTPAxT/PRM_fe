import '../../../../shared/models/user.dart';
import '../../../../shared/models/address.dart';
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
  Future<List<Address>> getAddresses() async {
    final response = await _remoteDataSource.getAddresses();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải sổ địa chỉ.');
  }

  @override
  Future<Address> createAddress({
    required String fullName,
    required String phone,
    required String detail,
    required bool isDefault,
  }) async {
    final response = await _remoteDataSource.createAddress(
      fullName: fullName,
      phone: phone,
      detail: detail,
      isDefault: isDefault,
    );
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Thêm địa chỉ thất bại.');
  }

  @override
  Future<Address> updateAddress({
    required String id,
    required String fullName,
    required String phone,
    required String detail,
  }) async {
    final response = await _remoteDataSource.updateAddress(
      id: id,
      fullName: fullName,
      phone: phone,
      detail: detail,
    );
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Cập nhật địa chỉ thất bại.');
  }

  @override
  Future<void> deleteAddress({required String id}) async {
    final response = await _remoteDataSource.deleteAddress(id);
    if (!response.success) {
      throw Exception(response.message ?? 'Xóa địa chỉ thất bại.');
    }
  }

  @override
  Future<Address> setDefaultAddress({required String id}) async {
    final response = await _remoteDataSource.setDefaultAddress(id);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Đặt địa chỉ mặc định thất bại.');
  }

  @override
  Future<User> updateProfile({
    required String fullName,
    String? email,
    String? phone,
  }) async {
    final response = await _remoteDataSource.updateProfile(
      fullName: fullName,
      email: email,
      phone: phone,
    );
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Cập nhật hồ sơ thất bại.');
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Đổi mật khẩu thất bại.');
    }
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
