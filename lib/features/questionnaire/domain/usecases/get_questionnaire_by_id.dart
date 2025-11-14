import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';

class GetQuestionnaireById {
  GetQuestionnaireById(this._repository);

  final QuestionnaireRepository _repository;

  Future<Either<Failure, QuestionnaireModel>> call(String id) async {
    return _repository.getQuestionnaireById(id);
  }
}
