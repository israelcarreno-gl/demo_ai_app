import 'package:demoai/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:demoai/features/questionnaire/data/datasources/questionnaire_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockQuestionnaireRemoteDataSource extends Mock
    implements QuestionnaireRemoteDataSource {}
