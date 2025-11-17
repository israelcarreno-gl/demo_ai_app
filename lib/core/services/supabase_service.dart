import 'package:demoai/core/config/app_config.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class SupabaseService {
  SupabaseService(this._config);

  final AppConfig _config;
  SupabaseClient? _client;

  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  Future<void> initialize() async {
    if (_config.supabaseUrl.isEmpty || _config.supabaseAnonKey.isEmpty) {
      throw Exception(
        'Supabase credentials not configured for ${_config.environment.name}',
      );
    }

    await Supabase.initialize(
      url: _config.supabaseUrl,
      anonKey: _config.supabaseAnonKey,
    );

    _client = Supabase.instance.client;
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  Future<List<Map<String, dynamic>>> query(String table) async {
    return await client.from(table).select();
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    await client.from(table).insert(data);
  }

  Future<void> update(
    String table,
    Map<String, dynamic> data,
    String column,
    Object value,
  ) async {
    await client.from(table).update(data).eq(column, value);
  }

  Future<void> delete(String table, String column, Object value) async {
    await client.from(table).delete().eq(column, value);
  }
}
