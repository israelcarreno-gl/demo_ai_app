import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/core/services/supabase_service.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionnaireRepositoryImpl implements QuestionnaireRepository {
  QuestionnaireRepositoryImpl(this._supabaseService);

  final SupabaseService _supabaseService;
  static const String _tableName = 'questionnaires';

  @override
  Future<Either<Failure, QuestionnaireModel>> generateQuestionnaire({
    required QuestionnaireGenerationRequest request,
    required String storagePath,
  }) async {
    try {
      // Call Edge Function to generate questionnaire
      final response = await _supabaseService.client.functions.invoke(
        'generate-questionnaire',
        body: {
          'user_id': request.userId,
          'document_path': storagePath,
          'document_name': request.documentName,
          'document_size': request.documentSize,
          'document_type': request.documentType,
          'question_type': _questionTypeToString(request.questionType),
          'number_of_questions': request.numberOfQuestions,
          'difficulty': _difficultyToString(request.difficulty),
        },
      );

      // Check for errors in response
      if (response.data == null) {
        return const Left(
          ServerFailure(message: 'No data received from server'),
        );
      }

      // Check if response contains error
      if (response.data is Map && response.data['error'] != null) {
        final error = response.data['error'];
        final errorMessage = error is Map && error['message'] != null
            ? error['message'].toString()
            : 'Unknown error occurred';
        return Left(ServerFailure(message: errorMessage));
      }

      // Parse response to QuestionnaireModel
      final questionnaireData = response.data as Map<String, dynamic>;

      log('Questionnaire generation response: $questionnaireData');

      final questionnaire = QuestionnaireModel.fromJson(questionnaireData);

      return Right(questionnaire);
    } on FunctionException catch (e) {
      final errorMessage = e.details != null && e.details is Map
          ? (e.details!['message']?.toString() ??
                e.reasonPhrase ??
                'Function error')
          : (e.reasonPhrase ?? 'Function error');
      return Left(ServerFailure(message: errorMessage));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to generate questionnaire: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<QuestionnaireModel>>> getUserQuestionnaires(
    String userId,
  ) async {
    try {
      // Query the questionnaires table directly and include nested questions
      final data = await _supabaseService.client
          .from(_tableName)
          .select('*, questions(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final questionnairesList = data as List<dynamic>;
      final questionnaires = questionnairesList
          .map(
            (json) => QuestionnaireModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return Right(questionnaires);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuestionnaireModel>> getQuestionnaireById(
    String id,
  ) async {
    try {
      final data = await _supabaseService.client
          .from(_tableName)
          .select('*, questions(*)')
          .eq('id', id)
          .single();

      return Right(QuestionnaireModel.fromJson(data));
    } catch (e) {
      log('Failed to fetch questionnaire by id=$id: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuestionnaireModel>> createQuestionnaire(
    QuestionnaireModel questionnaire,
  ) async {
    try {
      final data = await _supabaseService.client
          .from(_tableName)
          .insert(questionnaire.toJson())
          .select()
          .single();

      return Right(QuestionnaireModel.fromJson(data));
    } catch (e) {
      log('Failed updating questionnaire id=${questionnaire.id}: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuestionnaireModel>> updateQuestionnaire(
    QuestionnaireModel questionnaire,
  ) async {
    try {
      final payload = Map<String, dynamic>.from(questionnaire.toJson());
      // Remove nested questions from payload when updating questionnaire top-level fields
      payload.remove('questions');
      log('Updating questionnaire id=${questionnaire.id} with: $payload');
      final data = await _supabaseService.client
          .from(_tableName)
          .update(payload)
          .eq('id', questionnaire.id)
          .select()
          .single();

      // just to make sure the updqate was successful
      if (data['accuracy'] != questionnaire.accuracy ||
          data['completion_time'] != questionnaire.completionTime) {
        final analyticsPayload = <String, dynamic>{
          'accuracy': questionnaire.accuracy,
          'completion_time': questionnaire.completionTime,
          'summary': questionnaire.summary,
          'updated_at': questionnaire.updatedAt?.toIso8601String(),
        };
        log(
          'Re-updating analytics fields for questionnaire id=${questionnaire.id} with: $analyticsPayload',
        );
        final data2 = await _supabaseService.client
            .from(_tableName)
            .update(analyticsPayload)
            .eq('id', questionnaire.id)
            .select()
            .single();
        log('Re-update response: $data2');
        return Right(QuestionnaireModel.fromJson(data2));
      }
      log('Update response for questionnaire id=${questionnaire.id}: $data');

      return Right(QuestionnaireModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuestionnaire(String id) async {
    try {
      await _supabaseService.client.from(_tableName).delete().eq('id', id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Helper methods to convert enums to backend format
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
}
