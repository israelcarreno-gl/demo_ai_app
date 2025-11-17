import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:demoai/features/auth/data/models/user_model.dart';
import 'package:demoai/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  Future<void> _syncUserToDatabase(User user) async {
    try {
      await _remoteDataSource.upsertUser(user);
    } catch (e) {
      log('Failed to sync user to database: $e');
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(ServerFailure(message: 'Sign in failed'));
      }

      await _syncUserToDatabase(response.user!);

      return Right(UserModel.fromSupabaseUser(response.user!));
    } on AuthException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(ServerFailure(message: 'Sign up failed'));
      }

      await _syncUserToDatabase(response.user!);

      return Right(UserModel.fromSupabaseUser(response.user!));
    } on AuthException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = _remoteDataSource.currentUser;
      if (user == null) {
        return const Right(null);
      }
      return Right(UserModel.fromSupabaseUser(user));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((authState) {
      final user = authState.session?.user;
      return user != null ? UserModel.fromSupabaseUser(user) : null;
    });
  }
}
