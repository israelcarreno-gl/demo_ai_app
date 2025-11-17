import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/usecases/generate_questionnaire.dart';
import 'package:demoai/features/questionnaire/domain/usecases/get_questionnaire_by_id.dart';
import 'package:demoai/features/questionnaire/domain/usecases/get_user_questionnaires.dart';
import 'package:demoai/features/questionnaire/domain/usecases/upload_document.dart';
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserQuestionnaires extends Mock implements GetUserQuestionnaires {}

class MockGenerateQuestionnaire extends Mock implements GenerateQuestionnaire {}

class MockUploadDocument extends Mock implements UploadDocument {}

class MockGetQuestionnaireById extends Mock implements GetQuestionnaireById {}

void main() {
  late QuestionnaireBloc bloc;
  late MockGetUserQuestionnaires mockGetUserQuestionnaires;

  setUp(() {
    mockGetUserQuestionnaires = MockGetUserQuestionnaires();
    final mockGenerate = MockGenerateQuestionnaire();
    final mockUpload = MockUploadDocument();
    final mockGetById = MockGetQuestionnaireById();

    bloc = QuestionnaireBloc(
      generateQuestionnaire: mockGenerate,
      uploadDocument: mockUpload,
      getQuestionnaireById: mockGetById,
      getUserQuestionnaires: mockGetUserQuestionnaires,
    );
  });

  tearDown(() => bloc.close());

  group('GetUserQuestionnairesRequested', () {
    final model = QuestionnaireModel(
      id: 'q1',
      userId: 'u1',
      title: 'Test',
      createdAt: DateTime.now(),
    );

    blocTest<QuestionnaireBloc, QuestionnaireState>(
      'emits [QuestionnaireLoading, QuestionnaireListLoaded] when getUserQuestionnaires succeeds',
      build: () {
        when(
          () => mockGetUserQuestionnaires('u1'),
        ).thenAnswer((_) async => Right([model]));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetUserQuestionnairesRequested('u1')),
      expect: () => [
        QuestionnaireLoading(),
        QuestionnaireListLoaded([model]),
      ],
    );
  });
}
