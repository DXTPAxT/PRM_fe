import '../repositories/auth_repository.dart';
import '../../data/models/auth_models.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthResponse> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
