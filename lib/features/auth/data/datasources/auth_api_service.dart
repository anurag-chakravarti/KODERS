import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response.dart';

class AuthApiService {
  final DioClient _dioClient;

  AuthApiService(this._dioClient);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      // Dio exceptions are handled in Repository or passed up
      rethrow;
    }
  }
}
