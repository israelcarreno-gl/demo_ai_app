import 'package:demoai/features/questionnaire/data/models/question_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_model.freezed.dart';

@freezed
class QuestionnaireModel with _$QuestionnaireModel {
  const factory QuestionnaireModel({
    required String id,
    required String userId,
    required String title,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? description,
    @Default('draft') String status,
    String? documentName,
    int? documentSize,
    String? documentType,
    List<QuestionModel>? questions,
    double? accuracy,
    int? completionTime,
    int? estimatedTime,
    String? summary,
  }) = _QuestionnaireModel;

  const QuestionnaireModel._();

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'draft',
      documentName: json['document_name'] as String?,
      documentSize: json['document_size'] as int?,
      documentType: json['document_type'] as String?,
      accuracy: (json['accuracy'] != null)
          ? (json['accuracy'] as num).toDouble()
          : null,
      completionTime: json['completion_time'] as int?,
      estimatedTime: json['estimated_time'] as int?,
      summary: json['summary'] as String?,
      questions: json['questions'] != null
          ? (json['questions'] as List)
                .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'description': description,
      'status': status,
      'document_name': documentName,
      'document_size': documentSize,
      'document_type': documentType,
      'accuracy': accuracy,
      'completion_time': completionTime,
      'estimated_time': estimatedTime,
      'summary': summary,
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
  }
}
