// Domain entities imported where needed by the BLoC and repository
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:equatable/equatable.dart';

abstract class QuestionnaireResponseEvent extends Equatable {
  const QuestionnaireResponseEvent();
}

class StartQuestionnaire extends QuestionnaireResponseEvent {
  const StartQuestionnaire(this.questionnaire);
  final QuestionnaireModel questionnaire;

  @override
  List<Object?> get props => [questionnaire];
}

class AnswerSelected extends QuestionnaireResponseEvent {
  // for argument

  const AnswerSelected({
    required this.questionId,
    this.selectedIndices,
    this.answerText,
  });
  final String questionId;
  final List<int>? selectedIndices;
  final String? answerText;

  @override
  List<Object?> get props => [questionId, selectedIndices, answerText];
}

class NextQuestionRequested extends QuestionnaireResponseEvent {
  const NextQuestionRequested();

  @override
  List<Object?> get props => [];
}

class PreviousQuestionRequested extends QuestionnaireResponseEvent {
  const PreviousQuestionRequested();

  @override
  List<Object?> get props => [];
}

class SubmitResponsesRequested extends QuestionnaireResponseEvent {
  const SubmitResponsesRequested();

  @override
  List<Object?> get props => [];
}

class ResetResponses extends QuestionnaireResponseEvent {
  const ResetResponses();

  @override
  List<Object?> get props => [];
}
