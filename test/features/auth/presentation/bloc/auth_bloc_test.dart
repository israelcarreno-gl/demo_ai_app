import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/auth/data/models/user_model.dart';
import 'package:demoai/features/auth/domain/repositories/auth_repository.dart';
import 'package:demoai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthBloc bloc;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    bloc = AuthBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('AuthBloc', () {
    const tUser = UserModel(id: 'u1', email: 'a@a.com');

    test('initial state should be AuthInitial', () {
      expect(bloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when check returns user',
      build: () {
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Right(tUser));
        return bloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [AuthLoading(), const Authenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when check returns null',
      build: () {
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [AuthLoading(), Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when sign in succeeds',
      build: () {
        when(
          () => mockRepository.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(tUser));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignInRequested(email: 'a@a.com', password: 'pass'),
      ),
      expect: () => [AuthLoading(), const Authenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when sign in fails',
      build: () {
        when(
          () => mockRepository.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignInRequested(email: 'a@a.com', password: 'pass'),
      ),
      expect: () => [AuthLoading(), const AuthError('Server error')],
    );
  });
}
