import 'package:dartz/dartz.dart';
//
import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:demoai/features/questionnaire/domain/usecases/generate_questionnaire.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuestionnaireRepository extends Mock
    implements QuestionnaireRepository {}

void main() {
  late GenerateQuestionnaire usecase;
  late MockQuestionnaireRepository mockRepository;

  setUp(() {
    mockRepository = MockQuestionnaireRepository();
    usecase = GenerateQuestionnaire(mockRepository);
    // register fallback for QuestionnaireGenerationRequest used by mocktail `any(named:)` calls
    registerFallbackValue(
      const QuestionnaireGenerationRequest(
        documentName: '',
        documentSize: 0,
        documentType: '',
        questionType: QuestionType.singleChoice,
        numberOfQuestions: 0,
        difficulty: QuestionDifficulty.easy,
        userId: '',
      ),
    );
  });

  test('should call repository and return generated questionnaire', () async {
    const request = QuestionnaireGenerationRequest(
      documentName: 'doc',
      documentSize: 1,
      documentType: 'pdf',
      questionType: QuestionType.singleChoice,
      numberOfQuestions: 1,
      difficulty: QuestionDifficulty.easy,
      userId: 'u1',
    );

    final model = QuestionnaireModel(
      id: 'q1',
      userId: 'u1',
      title: 'T',
      createdAt: DateTime.now(),
    );
    when(
      () => mockRepository.generateQuestionnaire(
        request: any(named: 'request'),
        storagePath: any(named: 'storagePath'),
      ),
    ).thenAnswer((_) async => Right(model));

    final result = await usecase(request: request, storagePath: 's');
    expect(result.isRight(), true);
    result.fold((l) => fail('expected Right'), (q) => expect(q.id, 'q1'));
  });
}
