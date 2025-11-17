import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_response_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveAnswer {
  SaveAnswer(this.repository);
  final QuestionnaireResponseRepository repository;

  Future<Either<Failure, void>> call({
    required String questionnaireId,
    required QuestionResponse response,
  }) {
    return repository.saveAnswer(
      questionnaireId: questionnaireId,
      response: response,
    );
  }
}
