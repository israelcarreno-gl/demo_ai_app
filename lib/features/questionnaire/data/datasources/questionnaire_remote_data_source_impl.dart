import 'package:demoai/core/services/supabase_service.dart';
import 'package:demoai/features/questionnaire/data/datasources/questionnaire_remote_data_source.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: QuestionnaireRemoteDataSource)
class QuestionnaireRemoteDataSourceImpl
    implements QuestionnaireRemoteDataSource {
  QuestionnaireRemoteDataSourceImpl(this._supabaseService);

  final SupabaseService _supabaseService;
  static const String _tableName = 'questionnaires';

  @override
  Future<Map<String, dynamic>> generateQuestionnaire({
    required QuestionnaireGenerationRequest request,
    required String storagePath,
  }) async {
    // Build a snake_case body expected by the Edge Function
    final body = <String, dynamic>{
      'user_id': request.userId,
      'document_path': storagePath,
      'document_name': request.documentName,
      'document_size': request.documentSize,
      'document_type': request.documentType,
      'question_type': _questionTypeToString(request.questionType),
      'number_of_questions': request.numberOfQuestions,
      'difficulty': _difficultyToString(request.difficulty),
    };
    final response = await _supabaseService.client.functions.invoke(
      'generate-questionnaire',
      body: body,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getUserQuestionnaires(String userId) async {
    final data = await _supabaseService.client
        .from(_tableName)
        .select('*, questions(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getQuestionnaireById(String id) async {
    final data = await _supabaseService.client
        .from(_tableName)
        .select('*, questions(*)')
        .eq('id', id)
        .single();
    return data;
  }

  @override
  Future<Map<String, dynamic>> createQuestionnaire(
    Map<String, dynamic> data,
  ) async {
    final res = await _supabaseService.client
        .from(_tableName)
        .insert(data)
        .select()
        .single();
    return res;
  }

  @override
  Future<Map<String, dynamic>> updateQuestionnaire(
    Map<String, dynamic> data,
    String id,
  ) async {
    final res = await _supabaseService.client
        .from(_tableName)
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return res;
  }

  @override
  Future<void> deleteQuestionnaire(String id) async {
    await _supabaseService.client.from(_tableName).delete().eq('id', id);
  }
}

String _questionTypeToString(QuestionType type) {
  switch (type) {
    case QuestionType.multiChoice:
      return 'multi_choice';
    case QuestionType.singleChoice:
      return 'single_choice';
    case QuestionType.argument:
      return 'argument';
    case QuestionType.random:
      return 'random';
  }
}

String _difficultyToString(QuestionDifficulty difficulty) {
  switch (difficulty) {
    case QuestionDifficulty.easy:
      return 'easy';
    case QuestionDifficulty.medium:
      return 'medium';
    case QuestionDifficulty.hard:
      return 'hard';
  }
}
