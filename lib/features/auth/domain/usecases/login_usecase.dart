import '../../../../core/network/data_state.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<DataState<AuthUser>> call({required String email, required String password}) {
    return _authRepository.login(email, password);
  }
}
