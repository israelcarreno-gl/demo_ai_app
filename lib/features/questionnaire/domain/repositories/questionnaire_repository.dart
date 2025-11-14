import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';

abstract class QuestionnaireRepository {
  Future<Either<Failure, List<QuestionnaireModel>>> getUserQuestionnaires(
    String userId,
  );

  Future<Either<Failure, QuestionnaireModel>> getQuestionnaireById(String id);

  Future<Either<Failure, QuestionnaireModel>> createQuestionnaire(
    QuestionnaireModel questionnaire,
  );

  Future<Either<Failure, QuestionnaireModel>> updateQuestionnaire(
    QuestionnaireModel questionnaire,
  );

  Future<Either<Failure, void>> deleteQuestionnaire(String id);
}
