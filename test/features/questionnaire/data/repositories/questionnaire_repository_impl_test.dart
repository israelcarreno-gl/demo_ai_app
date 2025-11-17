import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/data/repositories/questionnaire_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mock_datasources.dart';

void main() {
  late QuestionnaireRepositoryImpl repository;
  late MockQuestionnaireRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockQuestionnaireRemoteDataSource();
    repository = QuestionnaireRepositoryImpl(mockRemoteDataSource);
  });

  group('getUserQuestionnaires', () {
    final json = {
      'id': 'q1',
      'user_id': 'u1',
      'title': 'Test',
      'created_at': DateTime.now().toIso8601String(),
    };

    test('returns list of Questionnaires on success', () async {
      when(
        () => mockRemoteDataSource.getUserQuestionnaires(any()),
      ).thenAnswer((_) async => [json]);

      final result = await repository.getUserQuestionnaires('u1');
      expect(result.isRight(), true);
      result.fold(
        (f) => fail('expected Right'),
        (list) => expect(list.length, 1),
      );
      verify(() => mockRemoteDataSource.getUserQuestionnaires('u1')).called(1);
    });
  });

  group('getQuestionnaireById', () {
    final json = {
      'id': 'q1',
      'user_id': 'u1',
      'title': 'Test',
      'created_at': DateTime.now().toIso8601String(),
    };

    test('returns Questionnaire on success', () async {
      when(
        () => mockRemoteDataSource.getQuestionnaireById(any()),
      ).thenAnswer((_) async => json);

      final result = await repository.getQuestionnaireById('q1');
      expect(result.isRight(), true);
      result.fold((f) => fail('expected Right'), (q) => expect(q.id, 'q1'));
      verify(() => mockRemoteDataSource.getQuestionnaireById('q1')).called(1);
    });
  });

  group('createQuestionnaire', () {
    final json = {
      'id': 'q2',
      'user_id': 'u1',
      'title': 'New',
      'created_at': DateTime.now().toIso8601String(),
    };

    test('should create and return questionnaire', () async {
      when(
        () => mockRemoteDataSource.createQuestionnaire(any()),
      ).thenAnswer((_) async => json);

      final model = QuestionnaireRepositoryImpl(mockRemoteDataSource);
      final result = await model.createQuestionnaire(
        // create a minimal dummy QuestionnaireModel
        // directly using fromJson via repo is acceptable for the test
        // but we can use a generated model
        // For brevity, we'll call createQuestionnaire with minimal map inside the repo
        // so prepare a QuestionnaireModel
        // Using only required params
        QuestionnaireModel(
          id: 'q2',
          userId: 'u1',
          title: 'New',
          createdAt: DateTime.now(),
        ),
      );

      expect(result.isRight(), true);
      result.fold((f) => fail('expected Right'), (q) => expect(q.id, 'q2'));
    });
  });

  group('updateQuestionnaire', () {
    final json = {
      'id': 'q1',
      'user_id': 'u1',
      'title': 'Updated',
      'created_at': DateTime.now().toIso8601String(),
      'accuracy': 90.0,
      'completion_time': 100,
    };

    test('should update and return questionnaire', () async {
      when(
        () => mockRemoteDataSource.updateQuestionnaire(any(), any()),
      ).thenAnswer((_) async => json);

      final result = await repository.updateQuestionnaire(
        QuestionnaireModel(
          id: 'q1',
          userId: 'u1',
          title: 'Updated',
          createdAt: DateTime.now(),
        ),
      );

      expect(result.isRight(), true);
      result.fold(
        (f) => fail('expected Right'),
        (q) => expect(q.accuracy, 90.0),
      );
    });
  });

  group('deleteQuestionnaire', () {
    test('should delete questionnaire', () async {
      when(
        () => mockRemoteDataSource.deleteQuestionnaire(any()),
      ).thenAnswer((_) async => Future<void>.value());

      final result = await repository.deleteQuestionnaire('q1');
      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.deleteQuestionnaire('q1')).called(1);
    });
  });
}
