import '../entities/auth_user.dart';
import '../../../../core/network/data_state.dart';

abstract class AuthRepository {
  Future<DataState<AuthUser>> login(String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<AuthUser?> getCurrentUser();
}
