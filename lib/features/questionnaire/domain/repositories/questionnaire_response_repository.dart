import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';

abstract class QuestionnaireResponseRepository {
  Future<Either<Failure, void>> saveAnswer({
    required String questionnaireId,
    required QuestionResponse response,
  });

  Future<Either<Failure, void>> submitResponses({
    required String questionnaireId,
    required List<QuestionResponse> responses,
  });
}
