import 'package:dartz/dartz.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:demoai/features/questionnaire/domain/usecases/update_questionnaire.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuestionnaireRepository extends Mock
    implements QuestionnaireRepository {}

void main() {
  late UpdateQuestionnaire usecase;
  late MockQuestionnaireRepository mockRepository;

  setUp(() {
    mockRepository = MockQuestionnaireRepository();
    usecase = UpdateQuestionnaire(mockRepository);
  });

  test('should call repository and return updated questionnaire', () async {
    final model = QuestionnaireModel(
      id: 'q1',
      userId: 'u1',
      title: 'T',
      createdAt: DateTime.now(),
    );
    when(
      () => mockRepository.updateQuestionnaire(model),
    ).thenAnswer((_) async => Right(model));

    final result = await usecase(model);
    expect(result.isRight(), true);
    result.fold((l) => fail('expected Right'), (q) => expect(q.id, 'q1'));
  });
}
