import 'package:dartz/dartz.dart';
//
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:demoai/features/questionnaire/domain/usecases/get_user_questionnaires.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuestionnaireRepository extends Mock
    implements QuestionnaireRepository {}

void main() {
  late GetUserQuestionnaires usecase;
  late MockQuestionnaireRepository mockRepository;

  setUp(() {
    mockRepository = MockQuestionnaireRepository();
    usecase = GetUserQuestionnaires(mockRepository);
  });

  test('should get list of questionnaires from repository', () async {
    // arrange
    final model = QuestionnaireModel(
      id: 'q1',
      userId: 'u1',
      title: 'Test',
      createdAt: DateTime.now(),
    );
    when(
      () => mockRepository.getUserQuestionnaires('u1'),
    ).thenAnswer((_) async => Right([model]));

    // act
    final result = await usecase('u1');

    // assert
    expect(result.isRight(), true);
    result.fold(
      (f) => fail('expected right'),
      (list) => expect(list.length, 1),
    );
    verify(() => mockRepository.getUserQuestionnaires('u1')).called(1);
  });
}
