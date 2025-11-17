import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';

abstract class QuestionnaireRemoteDataSource {
  Future<Map<String, dynamic>> generateQuestionnaire({
    required QuestionnaireGenerationRequest request,
    required String storagePath,
  });

  Future<List<dynamic>> getUserQuestionnaires(String userId);

  Future<Map<String, dynamic>> getQuestionnaireById(String id);

  Future<Map<String, dynamic>> createQuestionnaire(Map<String, dynamic> data);

  Future<Map<String, dynamic>> updateQuestionnaire(
    Map<String, dynamic> data,
    String id,
  );

  Future<void> deleteQuestionnaire(String id);
}
