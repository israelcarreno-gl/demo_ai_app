part of 'questionnaire_bloc.dart';

abstract class QuestionnaireState extends Equatable {
  const QuestionnaireState();

  @override
  List<Object?> get props => [];
}

class QuestionnaireInitial extends QuestionnaireState {}

class QuestionnaireLoading extends QuestionnaireState {}

class QuestionnaireGenerated extends QuestionnaireState {
  const QuestionnaireGenerated(this.questionnaire);

  final QuestionnaireModel questionnaire;

  @override
  List<Object?> get props => [questionnaire];
}

class QuestionnaireLoaded extends QuestionnaireState {
  const QuestionnaireLoaded(this.questionnaire);

  final QuestionnaireModel questionnaire;

  @override
  List<Object?> get props => [questionnaire];
}

class QuestionnaireError extends QuestionnaireState {
  const QuestionnaireError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class QuestionnaireListLoaded extends QuestionnaireState {
  const QuestionnaireListLoaded(this.questionnaires);

  final List<QuestionnaireModel> questionnaires;

  @override
  List<Object?> get props => [questionnaires];
}
