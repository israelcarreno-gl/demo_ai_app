import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:demoai/core/error/failures.dart';
import 'package:demoai/features/questionnaire/data/datasources/questionnaire_remote_data_source.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: QuestionnaireRepository)
class QuestionnaireRepositoryImpl implements QuestionnaireRepository {
  QuestionnaireRepositoryImpl(this._remoteDataSource);

  final QuestionnaireRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, QuestionnaireModel>> generateQuestionnaire({
    required QuestionnaireGenerationRequest request,
    required String storagePath,
  }) async {
    try {
      // Call Edge Function to generate questionnaire via datasource
      final response = await _remoteDataSource.generateQuestionnaire(
        request: request,
        storagePath: storagePath,
      );

      // Check for errors in response
      if (response.isEmpty) {
        return const Left(
          ServerFailure(message: 'No data received from server'),
        );
      }

      // Check if response contains error
      if (response['error'] != null) {
        final error = response['error'];
        final errorMessage = error is Map && error['message'] != null
            ? error['message'].toString()
            : 'Unknown error occurred';
        return Left(ServerFailure(message: errorMessage));
      }

      // Parse response to QuestionnaireModel
      final questionnaireData = response;

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
      // Query the questionnaires table directly and include nested questions via datasource
      final data = await _remoteDataSource.getUserQuestionnaires(userId);

      final questionnairesList = data;
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
      final data = await _remoteDataSource.getQuestionnaireById(id);

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
      final data = await _remoteDataSource.createQuestionnaire(
        questionnaire.toJson(),
      );

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
      final data = await _remoteDataSource.updateQuestionnaire(
        payload,
        questionnaire.id,
      );

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
        final data2 = await _remoteDataSource.updateQuestionnaire(
          analyticsPayload,
          questionnaire.id,
        );
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
      await _remoteDataSource.deleteQuestionnaire(id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
