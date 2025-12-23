import 'package:dio/dio.dart';
import '../../../../core/network/data_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_api_service.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService _userApiService;

  UserRepositoryImpl(this._userApiService);

  @override
  Future<DataState<PaginatedUsersEntity>> getUsers({required int page}) async {
    try {
      // JSONPlaceholder returns the list directly
      // Assuming _apiService.getUsers now returns a HttpResponse<List<UserModel>>
      final response = await _userApiService.getUsers(page);
      
      // The response.data should be List<UserModel> because of Retrofit/Dio?
      // Wait, UserApiService needs update too.
      // Assuming ApiService returns List<UserModel>
      
      if (response.response.statusCode == 200) {
        // Simulating pagination since JSONPlaceholder returns all 10 users at once usually
        // We will double the list (20 items) and offset IDs to ensure they are unique across pages.
        final List<UserModel> rawModels = response.data;
        final List<UserModel> doubledModels = [...rawModels, ...rawModels]; // 20 items
        
        // Map to entities and offset IDs
        final entities = doubledModels.asMap().entries.map((entry) {
          final index = entry.key;
          final model = entry.value;
          // Calculate a unique ID: (page - 1) * 20 + index + 1
          final uniqueId = (page - 1) * 20 + index + 1;
          
          return model.toEntity().copyWith(id: uniqueId);
        }).toList();
        
        return DataSuccess(PaginatedUsersEntity(
          users: entities,
          totalPages: 5, // Simulating 5 pages of data (100 items total)
          currentPage: page,
        ));
      } else {
        return DataFailed(
          DioException(
            error: response.response.statusMessage,
            response: response.response,
            type: DioExceptionType.badResponse,
            requestOptions: response.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<UserEntity>> getUserDetails(int id) async {
    try {
      final response = await _userApiService.getUserDetails(id);
      return DataSuccess(response.data.toEntity());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
