import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:demoai/features/questionnaire/data/models/question_model.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/entities/question_response.dart';
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
  setUpAll(() {
    registerFallbackValue(
      QuestionnaireModel(
        id: 'q-fallback',
        userId: 'u-fallback',
        title: 'fallback',
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
  });
  late QuestionnaireResponseBloc bloc;
  late MockSaveAnswer mockSaveAnswer;
  late MockSubmitResponses mockSubmitResponses;
  late MockUpdateQuestionnaire mockUpdateQuestionnaire;

  setUp(() {
    mockSaveAnswer = MockSaveAnswer();
    mockSubmitResponses = MockSubmitResponses();
    mockUpdateQuestionnaire = MockUpdateQuestionnaire();

    registerFallbackValue(
      const QuestionResponse(
        questionId: 'q1',
        questionType: 'single_choice',
        selectedOptionIndices: [0],
      ),
    );

    bloc = QuestionnaireResponseBloc(
      saveAnswer: mockSaveAnswer,
      submitResponses: mockSubmitResponses,
      updateQuestionnaire: mockUpdateQuestionnaire,
    );
  });

  tearDown(() => bloc.close());

  blocTest<QuestionnaireResponseBloc, QuestionnaireResponseState>(
    'full flow with only auto-gradable questions computes accuracy and emits submitted',
    build: () {
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

      when(
        () => mockSaveAnswer.call(
          questionnaireId: any(named: 'questionnaireId'),
          response: any(named: 'response'),
        ),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockUpdateQuestionnaire.call(any()),
      ).thenAnswer((_) async => Right(questionnaire));

      return QuestionnaireResponseBloc(
        saveAnswer: mockSaveAnswer,
        submitResponses: mockSubmitResponses,
        updateQuestionnaire: mockUpdateQuestionnaire,
      );
    },
    act: (bloc) {
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

      bloc.add(StartQuestionnaire(questionnaire));
      bloc.add(const AnswerSelected(questionId: 'q1', selectedIndices: [0]));
      bloc.add(const NextQuestionRequested());
      bloc.add(const AnswerSelected(questionId: 'q2', selectedIndices: [0]));
      bloc.add(const SubmitResponsesRequested());
    },
    expect: () => [
      isA<QuestionnaireResponseInProgress>(),
      isA<QuestionnaireResponseInProgress>(),
      isA<QuestionnaireResponseInProgress>(),
      isA<QuestionnaireResponseInProgress>(),
      isA<QuestionnaireResponseSubmitting>(),
      isA<QuestionnaireResponseSubmitted>(),
    ],
    verify: (bloc) async {
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
