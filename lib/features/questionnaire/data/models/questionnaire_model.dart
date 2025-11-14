import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_model.freezed.dart';
part 'questionnaire_model.g.dart';

@freezed
class QuestionnaireModel with _$QuestionnaireModel {
  const factory QuestionnaireModel({
    required String id,
    required String userId,
    required String title,
    required DateTime createdAt,
    String? description,
    @Default('draft') String status,
  }) = _QuestionnaireModel;
  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireModelFromJson(json);

  const QuestionnaireModel._();

  @JsonKey(name: 'user_id')
  String get userIdJson => userId;

  @JsonKey(name: 'created_at')
  DateTime get createdAtJson => createdAt;
}
