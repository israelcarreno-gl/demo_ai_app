import 'package:dartz/dartz.dart';
import 'package:demoai/features/questionnaire/data/models/question_model.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/usecases/save_answer.dart';
import 'package:demoai/features/questionnaire/domain/usecases/submit_responses.dart';
import 'package:demoai/features/questionnaire/domain/usecases/update_questionnaire.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_bloc.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_event.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSaveAnswer extends Mock implements SaveAnswer {}

class MockSubmitResponses extends Mock implements SubmitResponses {}

class MockUpdateQuestionnaire extends Mock implements UpdateQuestionnaire {}

void main() {
  late QuestionnaireResponseBloc bloc;
  late MockSaveAnswer mockSaveAnswer;
  late MockSubmitResponses mockSubmitResponses;
  late MockUpdateQuestionnaire mockUpdateQuestionnaire;

  setUp(() {
    mockSaveAnswer = MockSaveAnswer();
    mockSubmitResponses = MockSubmitResponses();
    mockUpdateQuestionnaire = MockUpdateQuestionnaire();

    bloc = QuestionnaireResponseBloc(
      saveAnswer: mockSaveAnswer,
      submitResponses: mockSubmitResponses,
      updateQuestionnaire: mockUpdateQuestionnaire,
    );
  });

  tearDown(() => bloc.close());

  test(
    'full flow with only auto-gradable questions computes accuracy and emits submitted',
    () async {
      // Arrange: questionnaire with two single choice questions
      final q1 = QuestionModel(
        id: 'q1',
        questionnaireId: 'qq',
        questionText: 'Q1',
        questionType: 'single_choice',
        difficulty: 'easy',
        orderNum: 1,
        createdAt: DateTime.now(),
        options: ['A', 'B'],
        correctAnswer: 'A',
      );

      final q2 = QuestionModel(
        id: 'q2',
        questionnaireId: 'qq',
        questionText: 'Q2',
        questionType: 'single_choice',
        difficulty: 'easy',
        orderNum: 2,
        createdAt: DateTime.now(),
        options: ['A', 'B'],
        correctAnswer: 'B',
      );

      final questionnaire = QuestionnaireModel(
        id: 'qq',
        userId: 'u1',
        title: 'Test',
        createdAt: DateTime.now(),
        questions: [q1, q2],
      );

      // stub saveAnswer to complete
      when(
        () => mockSaveAnswer.call(
          questionnaireId: any(named: 'questionnaireId'),
          response: any(named: 'response'),
        ),
      ).thenAnswer((_) async => const Right(null));
      // stub updateQuestionnaire returns Right merged
      when(
        () => mockUpdateQuestionnaire.call(any()),
      ).thenAnswer((_) async => Right(questionnaire));
      // No argument type responses, so submitResponses should not be called

      // Act: start questionnaire
      bloc.add(StartQuestionnaire(questionnaire));

      // Answer q1 correctly: single choice index 0
      await Future.delayed(Duration.zero);
      bloc.add(const AnswerSelected(questionId: 'q1', selectedIndices: [0]));

      await Future.delayed(Duration.zero);
      bloc.add(const NextQuestionRequested());

      // Answer q2 incorrectly selected index 0 (correct is B => index 1)
      await Future.delayed(Duration.zero);
      bloc.add(const AnswerSelected(questionId: 'q2', selectedIndices: [0]));

      await Future.delayed(Duration.zero);
      bloc.add(const SubmitResponsesRequested());

      await Future.delayed(Duration.zero);

      // Expect the final state to be QuestionnaireResponseSubmitted
      final state = bloc.state;
      expect(state, isA<QuestionnaireResponseSubmitted>());
      final submitted = state as QuestionnaireResponseSubmitted;
      expect(submitted.correctCount, 1);
      expect(submitted.totalLocal, 2);
      expect(submitted.accuracy, 50.0);
      verify(() => mockUpdateQuestionnaire.call(any())).called(1);
      verifyNever(
        () => mockSubmitResponses.call(
          questionnaireId: any(named: 'questionnaireId'),
          responses: any(named: 'responses'),
        ),
      );
    },
  );
}
