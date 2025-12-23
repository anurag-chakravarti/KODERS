import 'package:flutter_test/flutter_test.dart';
import 'package:koders_flutter_project/core/network/data_state.dart';
import 'package:koders_flutter_project/features/auth/domain/entities/auth_user.dart';
import 'package:koders_flutter_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:koders_flutter_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password';
  const tAuthUser = AuthUser(token: 'test_token');

  test('should return AuthUser when login is successful', () async {
    // Arrange
    when(() => mockAuthRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => const DataSuccess(tAuthUser));

    // Act
    final result = await loginUseCase(email: tEmail, password: tPassword);

    // Assert
    expect(result, isA<DataSuccess<AuthUser>>());
    expect(result.data, tAuthUser);
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
  });
}
