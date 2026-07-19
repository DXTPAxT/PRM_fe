import '../../../../shared/models/user.dart';
import '../../../../shared/models/address.dart';
import '../../data/models/auth_models.dart';
import '../../data/models/otp_models.dart';

abstract class AuthRepository {
  Future<User> getCurrentUser();

  Future<List<Address>> getAddresses();

  Future<Address> createAddress({
    required String fullName,
    required String phone,
    required String detail,
    required bool isDefault,
  });

  Future<Address> updateAddress({
    required String id,
    required String fullName,
    required String phone,
    required String detail,
  });

  Future<void> deleteAddress({required String id});

  Future<Address> setDefaultAddress({required String id});

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
