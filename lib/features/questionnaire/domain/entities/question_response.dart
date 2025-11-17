import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_response.freezed.dart';

@freezed
class QuestionResponse with _$QuestionResponse {
  const factory QuestionResponse({
    required String questionId,
    required String questionType,
    // indices for selected options (0-based)
    List<int>? selectedOptionIndices,
    // free-text answer
    String? answerText,
  }) = _QuestionResponse;
}
