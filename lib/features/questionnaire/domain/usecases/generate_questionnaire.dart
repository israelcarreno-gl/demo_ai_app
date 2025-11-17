import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GenerateQuestionnaire {
  GenerateQuestionnaire(this._repository);

  final QuestionnaireRepository _repository;

  Future<Either<Failure, QuestionnaireModel>> call({
    required QuestionnaireGenerationRequest request,
    required String storagePath,
  }) async {
    return _repository.generateQuestionnaire(
      request: request,
      storagePath: storagePath,
    );
  }
}
