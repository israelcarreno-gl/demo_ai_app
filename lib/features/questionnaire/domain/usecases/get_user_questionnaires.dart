import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserQuestionnaires {
  GetUserQuestionnaires(this._repository);

  final QuestionnaireRepository _repository;

  Future<Either<Failure, List<QuestionnaireModel>>> call(String userId) {
    return _repository.getUserQuestionnaires(userId);
  }
}
