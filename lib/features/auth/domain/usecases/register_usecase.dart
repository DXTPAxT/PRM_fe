import '../repositories/auth_repository.dart';
import '../../data/models/otp_models.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<RegisterChallenge> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) {
    return _repository.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
  }
}
