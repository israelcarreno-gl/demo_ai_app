import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';

abstract class QuestionnaireRepository {
  /// Generate a questionnaire from a document using Edge Function
  Future<Either<Failure, QuestionnaireModel>> generateQuestionnaire({
    required QuestionnaireGenerationRequest request,
    required String storagePath,
  });

  /// Get all questionnaires for a user
  Future<Either<Failure, List<QuestionnaireModel>>> getUserQuestionnaires(
    String userId,
  );

  /// Get a questionnaire by ID with all questions
  Future<Either<Failure, QuestionnaireModel>> getQuestionnaireById(String id);

  /// Create a questionnaire manually
  Future<Either<Failure, QuestionnaireModel>> createQuestionnaire(
    QuestionnaireModel questionnaire,
  );

  /// Update a questionnaire
  Future<Either<Failure, QuestionnaireModel>> updateQuestionnaire(
    QuestionnaireModel questionnaire,
  );

  /// Delete a questionnaire
  Future<Either<Failure, void>> deleteQuestionnaire(String id);
}
