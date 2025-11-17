// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:demoai/core/config/app_config.dart' as _i676;
import 'package:demoai/core/services/storage_service.dart' as _i1030;
import 'package:demoai/core/services/supabase_service.dart' as _i614;
import 'package:demoai/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i582;
import 'package:demoai/features/auth/data/datasources/auth_remote_data_source_impl.dart'
    as _i1022;
import 'package:demoai/features/auth/data/repositories/auth_repository_impl.dart'
    as _i950;
import 'package:demoai/features/auth/domain/repositories/auth_repository.dart'
    as _i309;
import 'package:demoai/features/auth/presentation/bloc/auth_bloc.dart' as _i476;
import 'package:demoai/features/demo/domain/usecases/get_jokes_by_type.dart'
    as _i241;
import 'package:demoai/features/demo/domain/usecases/get_random_joke.dart'
    as _i220;
import 'package:demoai/features/demo/presentation/bloc/joke_bloc.dart' as _i676;
import 'package:demoai/features/questionnaire/data/datasources/questionnaire_remote_data_source.dart'
    as _i734;
import 'package:demoai/features/questionnaire/data/datasources/questionnaire_remote_data_source_impl.dart'
    as _i460;
import 'package:demoai/features/questionnaire/data/repositories/questionnaire_repository_impl.dart'
    as _i809;
import 'package:demoai/features/questionnaire/data/repositories/questionnaire_response_repository_impl.dart'
    as _i859;
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_repository.dart'
    as _i629;
import 'package:demoai/features/questionnaire/domain/repositories/questionnaire_response_repository.dart'
    as _i308;
import 'package:demoai/features/questionnaire/domain/usecases/generate_questionnaire.dart'
    as _i109;
import 'package:demoai/features/questionnaire/domain/usecases/get_questionnaire_by_id.dart'
    as _i520;
import 'package:demoai/features/questionnaire/domain/usecases/get_user_questionnaires.dart'
    as _i643;
import 'package:demoai/features/questionnaire/domain/usecases/save_answer.dart'
    as _i676;
import 'package:demoai/features/questionnaire/domain/usecases/submit_responses.dart'
    as _i569;
import 'package:demoai/features/questionnaire/domain/usecases/update_questionnaire.dart'
    as _i333;
import 'package:demoai/features/questionnaire/domain/usecases/upload_document.dart'
    as _i514;
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_bloc.dart'
    as _i94;
import 'package:demoai/features/questionnaire/presentation/bloc/questionnaire_response_bloc.dart'
    as _i421;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i614.SupabaseService>(
      () => _i614.SupabaseService(gh<_i676.AppConfig>()),
    );
    gh.factory<_i676.JokeBloc>(
      () => _i676.JokeBloc(
        getRandomJoke: gh<_i220.GetRandomJoke>(),
        getJokesByType: gh<_i241.GetJokesByType>(),
      ),
    );
    gh.lazySingleton<_i1030.StorageService>(
      () => _i1030.StorageService(gh<_i614.SupabaseService>()),
    );
    gh.lazySingleton<_i308.QuestionnaireResponseRepository>(
      () => _i859.QuestionnaireResponseRepositoryImpl(
        gh<_i614.SupabaseService>(),
      ),
    );
    gh.lazySingleton<_i734.QuestionnaireRemoteDataSource>(
      () =>
          _i460.QuestionnaireRemoteDataSourceImpl(gh<_i614.SupabaseService>()),
    );
    gh.factory<_i676.SaveAnswer>(
      () => _i676.SaveAnswer(gh<_i308.QuestionnaireResponseRepository>()),
    );
    gh.factory<_i569.SubmitResponses>(
      () => _i569.SubmitResponses(gh<_i308.QuestionnaireResponseRepository>()),
    );
    gh.lazySingleton<_i629.QuestionnaireRepository>(
      () => _i809.QuestionnaireRepositoryImpl(
        gh<_i734.QuestionnaireRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i582.AuthRemoteDataSource>(
      () => _i1022.AuthRemoteDataSourceImpl(gh<_i614.SupabaseService>()),
    );
    gh.factory<_i109.GenerateQuestionnaire>(
      () => _i109.GenerateQuestionnaire(gh<_i629.QuestionnaireRepository>()),
    );
    gh.factory<_i520.GetQuestionnaireById>(
      () => _i520.GetQuestionnaireById(gh<_i629.QuestionnaireRepository>()),
    );
    gh.factory<_i643.GetUserQuestionnaires>(
      () => _i643.GetUserQuestionnaires(gh<_i629.QuestionnaireRepository>()),
    );
    gh.factory<_i514.UploadDocument>(
      () => _i514.UploadDocument(gh<_i1030.StorageService>()),
    );
    gh.lazySingleton<_i309.AuthRepository>(
      () => _i950.AuthRepositoryImpl(gh<_i582.AuthRemoteDataSource>()),
    );
    gh.factory<_i94.QuestionnaireBloc>(
      () => _i94.QuestionnaireBloc(
        generateQuestionnaire: gh<_i109.GenerateQuestionnaire>(),
        uploadDocument: gh<_i514.UploadDocument>(),
        getQuestionnaireById: gh<_i520.GetQuestionnaireById>(),
        getUserQuestionnaires: gh<_i643.GetUserQuestionnaires>(),
      ),
    );
    gh.factory<_i333.UpdateQuestionnaire>(
      () => _i333.UpdateQuestionnaire(gh<_i629.QuestionnaireRepository>()),
    );
    gh.factory<_i476.AuthBloc>(
      () => _i476.AuthBloc(gh<_i309.AuthRepository>()),
    );
    gh.factory<_i421.QuestionnaireResponseBloc>(
      () => _i421.QuestionnaireResponseBloc(
        saveAnswer: gh<_i676.SaveAnswer>(),
        submitResponses: gh<_i569.SubmitResponses>(),
        updateQuestionnaire: gh<_i333.UpdateQuestionnaire>(),
      ),
    );
    return this;
  }
}
