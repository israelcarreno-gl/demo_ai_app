part of 'questionnaire_bloc.dart';

abstract class QuestionnaireEvent extends Equatable {
  const QuestionnaireEvent();

  @override
  List<Object?> get props => [];
}

class GenerateQuestionnaireRequested extends QuestionnaireEvent {
  const GenerateQuestionnaireRequested(this.data);

  final QuestionnaireGenerationData data;

  @override
  List<Object?> get props => [data];
}

class GetQuestionnaireRequested extends QuestionnaireEvent {
  const GetQuestionnaireRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class GetUserQuestionnairesRequested extends QuestionnaireEvent {
  const GetUserQuestionnairesRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}
