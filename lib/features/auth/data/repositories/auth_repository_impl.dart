import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/data_state.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';
import '../models/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final SharedPreferences _sharedPreferences;

  AuthRepositoryImpl(this._apiService, this._sharedPreferences);

  @override
  Future<DataState<AuthUser>> login(String email, String password) async {
    // Mock Authentication Logic (Local)
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Simple validation for mock purposes
      if (email.isNotEmpty && password.length >= 6) {
        const mockToken = "QpwL5tke4Pnpja7X4"; // Dummy token
        
        final user = AuthUser(
          email: email, 
          token: mockToken, 
        );

        // Save session
        await _sharedPreferences.setString('auth_token', mockToken);
        
        return DataSuccess(user);
      } else {
         return DataFailed(
            DioException.connectionError(
              requestOptions: RequestOptions(path: 'local_mock'),
              reason: "Invalid credentials (mock)",
            )
         );
      }
    } catch (e) {
       return DataFailed(DioException(requestOptions: RequestOptions(path: 'local_mock'), error: e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await _sharedPreferences.remove('auth_token');
  }

  @override
  Future<bool> isLoggedIn() async {
    return _sharedPreferences.containsKey('auth_token');
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final token = _sharedPreferences.getString('auth_token');
    if (token != null) {
      // Return a basic user if token exists
      return AuthUser(
          email: "user@mock.com", 
          token: token, 
      );
    }
    return null;
  }
}
