import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:demoai/core/di/injection_container.dart';
// Data models are used via events - no direct import required here
import 'package:demoai/features/questionnaire/data/models/question_model.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';
import 'package:demoai/features/questionnaire/domain/usecases/save_answer.dart';
import 'package:demoai/features/questionnaire/domain/usecases/submit_responses.dart';
import 'package:demoai/features/questionnaire/domain/usecases/update_questionnaire.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_bloc.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_event.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_state.dart';

class QuestionnaireResponseBloc
    extends Bloc<QuestionnaireResponseEvent, QuestionnaireResponseState> {
  QuestionnaireResponseBloc({
    required this.saveAnswer,
    required this.submitResponses,
    required this.updateQuestionnaire,
  }) : super(const QuestionnaireResponseInitial()) {
    on<StartQuestionnaire>(_onStartQuestionnaire);
    on<AnswerSelected>(_onAnswerSelected);
    on<NextQuestionRequested>(_onNextQuestionRequested);
    on<PreviousQuestionRequested>(_onPreviousQuestionRequested);
    on<SubmitResponsesRequested>(_onSubmitResponsesRequested);
    on<ResetResponses>(_onResetResponses);
  }
  final SaveAnswer saveAnswer;
  final SubmitResponses submitResponses;
  final UpdateQuestionnaire updateQuestionnaire;

  FutureOr<void> _onStartQuestionnaire(
    StartQuestionnaire event,
    Emitter<QuestionnaireResponseState> emit,
  ) {
    final questionnaire = event.questionnaire;
    emit(
      QuestionnaireResponseInProgress(
        questionnaire: questionnaire,
        currentIndex: 0,
        responses: const <String, QuestionResponse>{},
        startedAt: DateTime.now(),
      ),
    );
  }

  FutureOr<void> _onAnswerSelected(
    AnswerSelected event,
    Emitter<QuestionnaireResponseState> emit,
  ) async {
    final stateCur = state;
    if (stateCur is QuestionnaireResponseInProgress) {
      final responses = Map<String, QuestionResponse>.from(stateCur.responses);
      // Determine question type from questionnaire model
      QuestionModel? question;
      try {
        final list = stateCur.questionnaire.questions;
        if (list != null) {
          question = list.firstWhere((q) => q.id == event.questionId);
        }
      } catch (_) {
        question = null;
      }
      final qType =
          question?.questionType ??
          (event.selectedIndices != null
              ? 'multi_choice'
              : (event.answerText != null ? 'argument' : 'single_choice'));
      // Coerce selected indices for single choice to a single element list
      List<int>? coercedIndices;
      if (qType == 'single_choice' &&
          event.selectedIndices != null &&
          event.selectedIndices!.isNotEmpty) {
        coercedIndices = [event.selectedIndices!.first];
      } else if (event.selectedIndices != null) {
        coercedIndices = List<int>.from(event.selectedIndices!);
      } else {
        coercedIndices = null;
      }

      final newResponse = QuestionResponse(
        questionId: event.questionId,
        questionType: qType,
        selectedOptionIndices: coercedIndices,
        answerText: event.answerText,
      );

      responses[event.questionId] = newResponse;

      // Save locally through usecase
      await saveAnswer.call(
        questionnaireId: stateCur.questionnaire.id,
        response: newResponse,
      );

      emit(
        QuestionnaireResponseInProgress(
          questionnaire: stateCur.questionnaire,
          currentIndex: stateCur.currentIndex,
          responses: responses,
          startedAt: stateCur.startedAt,
        ),
      );
    }
  }

  FutureOr<void> _onNextQuestionRequested(
    NextQuestionRequested event,
    Emitter<QuestionnaireResponseState> emit,
  ) {
    final stateCur = state;
    if (stateCur is QuestionnaireResponseInProgress) {
      final currentIndex = stateCur.currentIndex;
      final questions = stateCur.questionnaire.questions ?? [];
      if (currentIndex < (questions.length)) {
        final currentQuestion = questions[currentIndex];
        final response = stateCur.responses[currentQuestion.id];
        // Prevent moving forward if unanswered (for non-argument)
        final answered = _isAnswered(currentQuestion, response);
        if (!answered) {
          emit(
            const QuestionnaireResponseError(
              message: 'Please answer the current question before continuing.',
            ),
          );
        } else {
          if ((stateCur.questionnaire.questions?.length ?? 1) - 1 >
              currentIndex) {
            emit(
              QuestionnaireResponseInProgress(
                questionnaire: stateCur.questionnaire,
                currentIndex: currentIndex + 1,
                responses: stateCur.responses,
                startedAt: stateCur.startedAt,
              ),
            );
          }
        }
      } else {
        if ((stateCur.questionnaire.questions?.length ?? 1) - 1 >
            currentIndex) {
          emit(
            QuestionnaireResponseInProgress(
              questionnaire: stateCur.questionnaire,
              currentIndex: currentIndex + 1,
              responses: stateCur.responses,
              startedAt: stateCur.startedAt,
            ),
          );
        }
      }
    }
  }

  FutureOr<void> _onPreviousQuestionRequested(
    PreviousQuestionRequested event,
    Emitter<QuestionnaireResponseState> emit,
  ) {
    final stateCur = state;
    if (stateCur is QuestionnaireResponseInProgress) {
      final currentIndex = stateCur.currentIndex;
      if (currentIndex > 0) {
        emit(
          QuestionnaireResponseInProgress(
            questionnaire: stateCur.questionnaire,
            currentIndex: currentIndex - 1,
            responses: stateCur.responses,
            startedAt: stateCur.startedAt,
          ),
        );
      }
    }
  }

  FutureOr<void> _onSubmitResponsesRequested(
    SubmitResponsesRequested event,
    Emitter<QuestionnaireResponseState> emit,
  ) async {
    final stateCur = state;
    if (stateCur is QuestionnaireResponseInProgress) {
      emit(const QuestionnaireResponseSubmitting());

      final questionnaire = stateCur.questionnaire;
      final allQuestions = questionnaire.questions ?? [];

      // Separate argument responses to send to backend and local ones to validate
      final argumentResponses = <QuestionResponse>[];
      final localResponses = <QuestionResponse>[];

      for (final q in allQuestions) {
        final r = stateCur.responses[q.id];
        if (r == null) continue;
        if (q.questionType == 'argument') {
          argumentResponses.add(r);
        } else {
          localResponses.add(r);
        }
      }

      // Validate local responses
      int correctCount = 0;
      final perQuestionCorrect = <String, bool>{};
      for (final r in localResponses) {
        final q = allQuestions.firstWhere((qq) => qq.id == r.questionId);
        final isCorrect = _isResponseCorrect(q, r);
        perQuestionCorrect[r.questionId] = isCorrect;
        if (isCorrect) correctCount++;
      }

      // Compute timing and accuracy
      final startedAt = stateCur.startedAt;
      final completionTime = DateTime.now().difference(startedAt).inSeconds;
      final totalLocalAnswered = localResponses.length;
      // Accuracy is computed only for non-argument (auto-gradable) questions
      final accuracy = totalLocalAnswered > 0
          ? (correctCount / totalLocalAnswered) * 100.0
          : 0.0;

      // Persist the computed metrics to the questionnaire
      final updatedQuestionnaire = questionnaire.copyWith(
        accuracy: accuracy,
        completionTime: completionTime,
        updatedAt: DateTime.now(),
      );

      // Try to update questionnaire and prefer the server response if successful
      final updateResult = await updateQuestionnaire.call(updatedQuestionnaire);
      QuestionnaireModel questionnaireFromServer = updatedQuestionnaire;
      updateResult.fold(
        (failure) {
          // ignore failure but keep local copy; log for debugging
          // Note: Consider emitting an error state in the future if updates fail
          log('Failed to update questionnaire: ${failure.message}');
        },
        (q) {
          questionnaireFromServer = q;
          log('Questionnaire updated successfully on server: ${q.toJson()}');
          try {
            getIt<QuestionnaireBloc>().add(
              GetUserQuestionnairesRequested(questionnaireFromServer.userId),
            );
          } catch (_) {
            // ignore if bloc not available
          }
        },
      );
      if (argumentResponses.isNotEmpty) {
        final result = await submitResponses.call(
          questionnaireId: questionnaire.id,
          responses: argumentResponses,
        );
        result.fold(
          (failure) =>
              emit(QuestionnaireResponseError(message: failure.message)),
          (_) {
            emit(
              QuestionnaireResponseSubmitted(
                questionnaire: questionnaireFromServer,
                correctCount: correctCount,
                totalLocal: localResponses.length,
                perQuestionCorrect: perQuestionCorrect,
                accuracy: accuracy,
                completionTime: completionTime,
              ),
            );
          },
        );
      } else {
        // No backend interaction required
        emit(
          QuestionnaireResponseSubmitted(
            questionnaire: questionnaireFromServer,
            correctCount: correctCount,
            totalLocal: localResponses.length,
            perQuestionCorrect: perQuestionCorrect,
            accuracy: accuracy,
            completionTime: completionTime,
          ),
        );
      }
    }
  }

  FutureOr<void> _onResetResponses(
    ResetResponses event,
    Emitter<QuestionnaireResponseState> emit,
  ) async {
    // reset to initial
    emit(const QuestionnaireResponseInitial());
  }
}

// Helper: check if response matches correct answer for a question
bool _isResponseCorrect(QuestionModel q, QuestionResponse r) {
  // If no correct answer provided, consider it false
  if ((q.correctAnswer ?? '').isEmpty) return false;

  final correctLetters = q.correctAnswer!
      .split(',')
      .map((s) => s.trim().toUpperCase())
      .toList();
  final correctIndices = correctLetters
      .map((letter) => letter.codeUnitAt(0) - 'A'.codeUnitAt(0))
      .toSet();

  final selectedIndices = (r.selectedOptionIndices ?? []).toSet();

  return selectedIndices.length == correctIndices.length &&
      selectedIndices.difference(correctIndices).isEmpty;
}

// Helper: check if question has been answered (for UI and flow validation)
bool _isAnswered(QuestionModel q, QuestionResponse? r) {
  if (r == null) return false;
  if (q.questionType == 'argument') {
    return (r.answerText ?? '').trim().isNotEmpty;
  }
  // for single and multi choice, check selected indices
  return r.selectedOptionIndices != null && r.selectedOptionIndices!.isNotEmpty;
}
