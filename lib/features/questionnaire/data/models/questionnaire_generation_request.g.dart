// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_generation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireGenerationRequestImpl
_$$QuestionnaireGenerationRequestImplFromJson(Map<String, dynamic> json) =>
    _$QuestionnaireGenerationRequestImpl(
      documentName: json['documentName'] as String,
      documentSize: (json['documentSize'] as num).toInt(),
      documentType: json['documentType'] as String,
      questionType: $enumDecode(_$QuestionTypeEnumMap, json['questionType']),
      numberOfQuestions: (json['numberOfQuestions'] as num).toInt(),
      difficulty: $enumDecode(_$QuestionDifficultyEnumMap, json['difficulty']),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$QuestionnaireGenerationRequestImplToJson(
  _$QuestionnaireGenerationRequestImpl instance,
) => <String, dynamic>{
  'documentName': instance.documentName,
  'documentSize': instance.documentSize,
  'documentType': instance.documentType,
  'questionType': _$QuestionTypeEnumMap[instance.questionType]!,
  'numberOfQuestions': instance.numberOfQuestions,
  'difficulty': _$QuestionDifficultyEnumMap[instance.difficulty]!,
  'userId': instance.userId,
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
