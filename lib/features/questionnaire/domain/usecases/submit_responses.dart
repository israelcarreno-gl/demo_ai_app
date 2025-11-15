import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_response_repository.dart';

class SubmitResponses {
  SubmitResponses(this.repository);
  final QuestionnaireResponseRepository repository;

  Future<Either<Failure, void>> call({
    required String questionnaireId,
    required List<QuestionResponse> responses,
  }) {
    return repository.submitResponses(
      questionnaireId: questionnaireId,
      responses: responses,
    );
  }
}
