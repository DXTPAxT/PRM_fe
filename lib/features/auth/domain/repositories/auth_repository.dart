import '../../../../shared/models/user.dart';
import '../../data/models/auth_models.dart';
import '../../data/models/otp_models.dart';

abstract class AuthRepository {
  Future<User> getCurrentUser();

  Future<User> updateProfile({
    required String fullName,
    String? email,
    String? phone,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<AuthResponse> login({required String email, required String password});

  Future<void> logout({required String refreshToken});

  Future<RegisterChallenge> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  Future<AuthResponse> verifyOtp({required String email, required String otp});

  Future<RegisterChallenge> resendOtp({required String identifier});

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}
