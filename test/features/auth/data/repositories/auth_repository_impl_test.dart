// test imports
import 'package:demoai/features/auth/data/repositories/auth_repository_impl.dart';
// more test imports
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks/mock_datasources.dart';
import '../../../../mocks/mock_responses.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthResponse mockAuthResponse;
  late MockUser mockUser;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
    mockAuthResponse = MockAuthResponse();
    mockUser = MockUser();
  });

  group('signInWithEmail', () {
    test(
      'should return UserModel when remote data source yields user',
      () async {
        // arrange
        when(() => mockAuthResponse.user).thenReturn(mockUser);
        when(() => mockUser.id).thenReturn('user-id');
        when(() => mockUser.email).thenReturn('a@a.com');
        when(
          () => mockRemoteDataSource.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockAuthResponse);
        when(
          () => mockRemoteDataSource.upsertUser(mockUser),
        ).thenAnswer((_) async => Future<void>.value());

        // act
        final result = await repository.signInWithEmail(
          email: 'a@a.com',
          password: 'pass',
        );

        // assert
        expect(result.isRight(), true);
        result.fold(
          (f) => fail('Expected Right'),
          (user) => expect(user.id, 'user-id'),
        );
        verify(
          () => mockRemoteDataSource.signInWithEmail(
            email: 'a@a.com',
            password: 'pass',
          ),
        ).called(1);
        verify(() => mockRemoteDataSource.upsertUser(mockUser)).called(1);
      },
    );
  });

  group('getCurrentUser', () {
    test('returns UserModel when currentUser is present', () async {
      when(() => mockRemoteDataSource.currentUser).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('user-id');
      when(() => mockUser.email).thenReturn('a@a.com');

      final result = await repository.getCurrentUser();
      expect(result.isRight(), true);
      final user = result.getOrElse(() => null);
      expect(user?.id, 'user-id');
    });
  });
}
