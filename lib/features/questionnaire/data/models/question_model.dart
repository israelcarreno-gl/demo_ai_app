import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    required String questionnaireId,
    required String questionText,
    required String questionType,
    required String difficulty,
    required int orderNum,
    required DateTime createdAt,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
  }) = _QuestionModel;

  const QuestionModel._();

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      questionnaireId: json['questionnaire_id'] as String,
      questionText: json['question_text'] as String,
      questionType: json['question_type'] as String,
      difficulty: json['difficulty'] as String,
      orderNum: json['order_num'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      options: json['options'] != null
          ? (json['options'] as List).map((e) => e.toString()).toList()
          : null,
      correctAnswer: json['correct_answer'] as String?,
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionnaire_id': questionnaireId,
      'question_text': questionText,
      'question_type': questionType,
      'difficulty': difficulty,
      'order_num': orderNum,
      'created_at': createdAt.toIso8601String(),
      'options': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
    };
  }
}
