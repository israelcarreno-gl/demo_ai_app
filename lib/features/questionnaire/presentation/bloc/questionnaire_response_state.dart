import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';
import 'package:equatable/equatable.dart';

abstract class QuestionnaireResponseState extends Equatable {
  const QuestionnaireResponseState();
}

class QuestionnaireResponseInitial extends QuestionnaireResponseState {
  const QuestionnaireResponseInitial();

  @override
  List<Object?> get props => [];
}

class QuestionnaireResponseInProgress extends QuestionnaireResponseState {
  // questionId -> response

  const QuestionnaireResponseInProgress({
    required this.questionnaire,
    required this.currentIndex,
    required this.responses,
    required this.startedAt,
  });
  final QuestionnaireModel questionnaire;
  final int currentIndex;
  final Map<String, QuestionResponse> responses;
  final DateTime startedAt;

  double get progress =>
      (currentIndex + 1) / (questionnaire.questions?.length ?? 1);

  @override
  List<Object?> get props => [
    questionnaire,
    currentIndex,
    responses,
    startedAt,
  ];
}

class QuestionnaireResponseSubmitting extends QuestionnaireResponseState {
  const QuestionnaireResponseSubmitting();

  @override
  List<Object?> get props => [];
}

class QuestionnaireResponseSubmitted extends QuestionnaireResponseState {
  // questionId -> isCorrect

  const QuestionnaireResponseSubmitted({
    required this.questionnaire,
    required this.correctCount,
    required this.totalLocal,
    required this.perQuestionCorrect,
    required this.responses,
    this.accuracy,
    this.completionTime,
  });
  final QuestionnaireModel questionnaire;
  final int correctCount;
  final int totalLocal;
  final Map<String, bool> perQuestionCorrect;
  final Map<String, QuestionResponse> responses;
  final double? accuracy;
  final int? completionTime;

  @override
  List<Object?> get props => [
    questionnaire,
    correctCount,
    totalLocal,
    perQuestionCorrect,
    responses,
    accuracy,
    completionTime,
  ];
}

class QuestionnaireResponseError extends QuestionnaireResponseState {
  const QuestionnaireResponseError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
