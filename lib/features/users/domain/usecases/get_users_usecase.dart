import '../../../../core/network/data_state.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository _repository;

  GetUsersUseCase(this._repository);

  Future<DataState<PaginatedUsersEntity>> call({required int page}) {
    return _repository.getUsers(page: page);
  }
}
