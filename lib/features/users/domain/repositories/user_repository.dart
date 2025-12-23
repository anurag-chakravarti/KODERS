import '../../../../core/network/data_state.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<DataState<PaginatedUsersEntity>> getUsers({required int page});
  Future<DataState<UserEntity>> getUserDetails(int id);
}
