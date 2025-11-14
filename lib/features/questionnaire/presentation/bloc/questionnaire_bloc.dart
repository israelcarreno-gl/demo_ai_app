import 'package:demoai/features/questionnaire/data/models/questionnaire_generation_request.dart';
import 'package:demoai/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:demoai/features/questionnaire/domain/usecases/generate_questionnaire.dart';
import 'package:demoai/features/questionnaire/domain/usecases/get_questionnaire_by_id.dart';
import 'package:demoai/features/questionnaire/domain/usecases/upload_document.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'questionnaire_event.dart';
part 'questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  QuestionnaireBloc({
    required this.generateQuestionnaire,
    required this.uploadDocument,
    required this.getQuestionnaireById,
  }) : super(QuestionnaireInitial()) {
    on<GenerateQuestionnaireRequested>(_onGenerateQuestionnaireRequested);
    on<GetQuestionnaireRequested>(_onGetQuestionnaireRequested);
  }

  final GenerateQuestionnaire generateQuestionnaire;
  final UploadDocument uploadDocument;
  final GetQuestionnaireById getQuestionnaireById;

  Future<void> _onGenerateQuestionnaireRequested(
    GenerateQuestionnaireRequested event,
    Emitter<QuestionnaireState> emit,
  ) async {
    emit(QuestionnaireLoading());

    // Step 1: Upload document to storage
    final uploadResult = await uploadDocument(
      file: event.data.documentFile,
      userId: event.data.request.userId,
      fileName: event.data.request.documentName,
    );

    final storagePath = uploadResult.fold((failure) {
      emit(QuestionnaireError(failure.message));
      return null;
    }, (path) => path);

    if (storagePath == null) return;

    // Step 2: Generate questionnaire via Edge Function
    final result = await generateQuestionnaire(
      request: event.data.request,
      storagePath: storagePath,
    );

    result.fold(
      (failure) => emit(QuestionnaireError(failure.message)),
      (questionnaire) => emit(QuestionnaireGenerated(questionnaire)),
    );
  }

  Future<void> _onGetQuestionnaireRequested(
    GetQuestionnaireRequested event,
    Emitter<QuestionnaireState> emit,
  ) async {
    emit(QuestionnaireLoading());

    final result = await getQuestionnaireById(event.id);

    result.fold(
      (failure) => emit(QuestionnaireError(failure.message)),
      (questionnaire) => emit(QuestionnaireLoaded(questionnaire)),
    );
  }
}
