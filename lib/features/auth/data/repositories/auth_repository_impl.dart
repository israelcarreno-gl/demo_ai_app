import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/core/services/supabase_service.dart';
import 'package:demoai/features/auth/data/models/user_model.dart';
import 'package:demoai/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._supabaseService);

  final SupabaseService _supabaseService;
  static const String _usersTable = 'users';

  Future<void> _syncUserToDatabase(User user) async {
    try {
      final userModel = UserModel.fromSupabaseUser(user);

      await _supabaseService.client.from(_usersTable).upsert({
        'id': userModel.id,
        'email': userModel.email,
        'phone': userModel.phone,
        'email_confirmed_at': userModel.emailConfirmedAt?.toIso8601String(),
        'last_sign_in_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');
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
      final response = await _supabaseService.signInWithEmail(
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
      final response = await _supabaseService.signUpWithEmail(
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
      await _supabaseService.signOut();
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
      await _supabaseService.resetPassword(email);
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
      final user = _supabaseService.currentUser;
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
    return _supabaseService.authStateChanges.map((authState) {
      final user = authState.session?.user;
      return user != null ? UserModel.fromSupabaseUser(user) : null;
    });
  }
}
