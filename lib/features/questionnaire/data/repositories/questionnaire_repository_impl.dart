import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/core/services/supabase_service.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';

class QuestionnaireRepositoryImpl implements QuestionnaireRepository {
  QuestionnaireRepositoryImpl(this._supabaseService);

  final SupabaseService _supabaseService;
  static const String _tableName = 'questionnaires';

  @override
  Future<Either<Failure, List<QuestionnaireModel>>> getUserQuestionnaires(
    String userId,
  ) async {
    try {
      final data = await _supabaseService.client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final questionnaires = data
          .map((json) => QuestionnaireModel.fromJson(json))
          .toList();

      return Right(questionnaires);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuestionnaireModel>> getQuestionnaireById(
    String id,
  ) async {
    try {
      final data = await _supabaseService.client
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return Right(QuestionnaireModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuestionnaireModel>> createQuestionnaire(
    QuestionnaireModel questionnaire,
  ) async {
    try {
      final data = await _supabaseService.client
          .from(_tableName)
          .insert(questionnaire.toJson())
          .select()
          .single();

      return Right(QuestionnaireModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuestionnaireModel>> updateQuestionnaire(
    QuestionnaireModel questionnaire,
  ) async {
    try {
      final data = await _supabaseService.client
          .from(_tableName)
          .update(questionnaire.toJson())
          .eq('id', questionnaire.id)
          .select()
          .single();

      return Right(QuestionnaireModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuestionnaire(String id) async {
    try {
      await _supabaseService.client.from(_tableName).delete().eq('id', id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
