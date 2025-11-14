import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_generation_request.freezed.dart';
part 'questionnaire_generation_request.g.dart';

enum QuestionType {
  @JsonValue('multi_choice')
  multiChoice,
  @JsonValue('single_choice')
  singleChoice,
  @JsonValue('argument')
  argument,
  @JsonValue('random')
  random,
}

enum QuestionDifficulty {
  @JsonValue('easy')
  easy,
  @JsonValue('medium')
  medium,
  @JsonValue('hard')
  hard,
}

@freezed
class QuestionnaireGenerationRequest with _$QuestionnaireGenerationRequest {
  const factory QuestionnaireGenerationRequest({
    required String documentName,
    required int documentSize,
    required String documentType,
    required QuestionType questionType,
    required int numberOfQuestions,
    required QuestionDifficulty difficulty,
    required String userId,
    File? documentFile,
  }) = _QuestionnaireGenerationRequest;

  factory QuestionnaireGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireGenerationRequestFromJson(json);
}
