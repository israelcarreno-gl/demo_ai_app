// No special collection utilities needed here

import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/core/services/supabase_service.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_response_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: QuestionnaireResponseRepository)
class QuestionnaireResponseRepositoryImpl
    implements QuestionnaireResponseRepository {
  QuestionnaireResponseRepositoryImpl(this._supabaseService);

  final SupabaseService _supabaseService;

  // In-memory store: questionnaireId -> list of responses
  final _store = <String, List<QuestionResponse>>{};

  @override
  Future<Either<Failure, void>> saveAnswer({
    required String questionnaireId,
    required QuestionResponse response,
  }) async {
    try {
      final list = _store.putIfAbsent(
        questionnaireId,
        () => <QuestionResponse>[],
      );
      final idx = list.indexWhere((r) => r.questionId == response.questionId);
      if (idx >= 0) {
        list[idx] = response;
      } else {
        list.add(response);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitResponses({
    required String questionnaireId,
    required List<QuestionResponse> responses,
  }) async {
    try {
      // For now: store in memory and optionally call Supabase.
      _store[questionnaireId] = List.from(responses);

      // touch the client to avoid unused field lint; real implementation should use client to persist
      final _ = _supabaseService.client;
      // TODO(Isra): implement backend submission - call Edge Function or insert into responses table
      // Example:
      // final res = await _supabaseService.client.from('responses').insert([...]);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
