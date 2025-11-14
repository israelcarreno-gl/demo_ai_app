import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> resetPassword(String email);

  Future<Either<Failure, UserModel?>> getCurrentUser();

  Stream<UserModel?> get authStateChanges;
}
