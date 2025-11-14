// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireModelImpl _$$QuestionnaireModelImplFromJson(
  Map<String, dynamic> json,
) => _$QuestionnaireModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  description: json['description'] as String?,
  status: json['status'] as String? ?? 'draft',
);

Map<String, dynamic> _$$QuestionnaireModelImplToJson(
  _$QuestionnaireModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'createdAt': instance.createdAt.toIso8601String(),
  'description': instance.description,
  'status': instance.status,
};
