import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateQuestionnaire {
  UpdateQuestionnaire(this.repository);
  final QuestionnaireRepository repository;

  Future<Either<Failure, QuestionnaireModel>> call(
    QuestionnaireModel questionnaire,
  ) {
    return repository.updateQuestionnaire(questionnaire);
  }
}
