import 'dart:developer';

import 'package:demoai/core/services/supabase_service.dart';
import 'package:demoai/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:demoai/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._supabaseService);

  final SupabaseService _supabaseService;
  static const String _usersTable = 'users';

  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _supabaseService.signInWithEmail(email: email, password: password);
  }

  @override
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return _supabaseService.signUpWithEmail(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _supabaseService.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _supabaseService.resetPassword(email);
  }

  @override
  User? get currentUser => _supabaseService.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _supabaseService.authStateChanges;

  @override
  Future<void> upsertUser(User user) async {
    try {
      final userModel = UserModel.fromSupabaseUser(user);

      final Map<String, dynamic> data = {
        'id': userModel.id,
        'email': userModel.email,
        'phone': userModel.phone,
        'email_confirmed_at': userModel.emailConfirmedAt?.toIso8601String(),
        'last_sign_in_at':
            userModel.lastSignInAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabaseService.client
          .from(_usersTable)
          .upsert(data, onConflict: 'id');
    } catch (e) {
      log('Failed to upsert user to database: $e');
      rethrow;
    }
  }
}
