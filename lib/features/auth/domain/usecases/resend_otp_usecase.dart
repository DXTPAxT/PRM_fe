import '../../data/models/otp_models.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  Future<RegisterChallenge> call({required String identifier}) {
    return _repository.resendOtp(identifier: identifier);
  }
}
