import '../repositories/auth_repository.dart';
import '../../data/models/auth_models.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<AuthResponse> call({required String email, required String otp}) {
    return _repository.verifyOtp(email: email, otp: otp);
  }
}
