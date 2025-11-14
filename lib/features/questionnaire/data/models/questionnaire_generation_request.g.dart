// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_generation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireGenerationRequestImpl
_$$QuestionnaireGenerationRequestImplFromJson(Map<String, dynamic> json) =>
    _$QuestionnaireGenerationRequestImpl(
      documentName: json['document_name'] as String,
      documentSize: (json['document_size'] as num).toInt(),
      documentType: json['document_type'] as String,
      questionType: $enumDecode(_$QuestionTypeEnumMap, json['question_type']),
      numberOfQuestions: (json['number_of_questions'] as num).toInt(),
      difficulty: $enumDecode(_$QuestionDifficultyEnumMap, json['difficulty']),
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$$QuestionnaireGenerationRequestImplToJson(
  _$QuestionnaireGenerationRequestImpl instance,
) => <String, dynamic>{
  'document_name': instance.documentName,
  'document_size': instance.documentSize,
  'document_type': instance.documentType,
  'question_type': _$QuestionTypeEnumMap[instance.questionType]!,
  'number_of_questions': instance.numberOfQuestions,
  'difficulty': _$QuestionDifficultyEnumMap[instance.difficulty]!,
  'user_id': instance.userId,
};

const _$QuestionTypeEnumMap = {
  QuestionType.multiChoice: 'multi_choice',
  QuestionType.singleChoice: 'single_choice',
  QuestionType.argument: 'argument',
  QuestionType.random: 'random',
};

const _$QuestionDifficultyEnumMap = {
  QuestionDifficulty.easy: 'easy',
  QuestionDifficulty.medium: 'medium',
  QuestionDifficulty.hard: 'hard',
};
