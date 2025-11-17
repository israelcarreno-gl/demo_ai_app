// import 'package:demoai/core/services/supabase_service.dart';
import 'package:demoai/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../mocks/mock_supabase_service.dart';

class FakeAuthResponse extends Fake implements AuthResponse {}

void main() {
  late AuthRemoteDataSourceImpl datasource;
  late MockSupabaseService mockSupabaseService;

  setUp(() {
    mockSupabaseService = MockSupabaseService();
    registerFallbackValue(FakeAuthResponse());
    datasource = AuthRemoteDataSourceImpl(mockSupabaseService);
  });

  group('signInWithEmail', () {
    test('delegates to SupabaseService.signInWithEmail', () async {
      // Arrange
      when(
        () => mockSupabaseService.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => FakeAuthResponse());

      // Act
      final res = await datasource.signInWithEmail(
        email: 'a@a.com',
        password: 'pass',
      );

      // Assert
      expect(res, isNotNull);
      verify(
        () => mockSupabaseService.signInWithEmail(
          email: 'a@a.com',
          password: 'pass',
        ),
      ).called(1);
      verifyNoMoreInteractions(mockSupabaseService);
    });
  });
}
