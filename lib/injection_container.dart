import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/datasources/auth_api_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/users/data/datasources/user_api_service.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/domain/usecases/get_users_usecase.dart';
import 'features/users/presentation/bloc/user_detail_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton<DioClient>(DioClient());

  // Features - Auth
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

  // Features - User
  sl.registerLazySingleton<UserApiService>(() => UserApiService(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<GetUsersUseCase>(() => GetUsersUseCase(sl()));

  // Blocs
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl()));
  sl.registerFactory<UserDetailBloc>(() => UserDetailBloc(sl()));

  // AppRouter
  sl.registerLazySingleton<AppRouter>(() => AppRouter());
}
