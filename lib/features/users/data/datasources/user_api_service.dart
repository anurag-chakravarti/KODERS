import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

part 'user_api_service.g.dart';

@RestApi()
abstract class UserApiService {
  factory UserApiService(DioClient dioClient) { 
    return _UserApiService(dioClient.dio);
  }

  @GET('/users')
  Future<HttpResponse<List<UserModel>>> getUsers(
    @Query("page") int page,
  );

  @GET('/users/{id}')
  Future<HttpResponse<UserModel>> getUserDetails(
    @Path("id") int id,
  );
}
