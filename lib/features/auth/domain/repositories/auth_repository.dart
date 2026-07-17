import '../../data/models/auth_models.dart';

abstract class AuthRepository {
  Future<AuthResponse> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  Future<void> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}
