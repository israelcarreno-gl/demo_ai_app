// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_generation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuestionnaireGenerationRequest _$QuestionnaireGenerationRequestFromJson(
  Map<String, dynamic> json,
) {
  return _QuestionnaireGenerationRequest.fromJson(json);
}

/// @nodoc
mixin _$QuestionnaireGenerationRequest {
  @JsonKey(includeToJson: false, includeFromJson: false)
  File? get documentFile => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_name')
  String get documentName => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_size')
  int get documentSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_type')
  String get documentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_type')
  QuestionType get questionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'number_of_questions')
  int get numberOfQuestions => throw _privateConstructorUsedError;
  QuestionDifficulty get difficulty => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this QuestionnaireGenerationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionnaireGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionnaireGenerationRequestCopyWith<QuestionnaireGenerationRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireGenerationRequestCopyWith<$Res> {
  factory $QuestionnaireGenerationRequestCopyWith(
    QuestionnaireGenerationRequest value,
    $Res Function(QuestionnaireGenerationRequest) then,
  ) =
      _$QuestionnaireGenerationRequestCopyWithImpl<
        $Res,
        QuestionnaireGenerationRequest
      >;
  @useResult
  $Res call({
    @JsonKey(includeToJson: false, includeFromJson: false) File? documentFile,
    @JsonKey(name: 'document_name') String documentName,
    @JsonKey(name: 'document_size') int documentSize,
    @JsonKey(name: 'document_type') String documentType,
    @JsonKey(name: 'question_type') QuestionType questionType,
    @JsonKey(name: 'number_of_questions') int numberOfQuestions,
    QuestionDifficulty difficulty,
    @JsonKey(name: 'user_id') String userId,
  });
}

/// @nodoc
class _$QuestionnaireGenerationRequestCopyWithImpl<
  $Res,
  $Val extends QuestionnaireGenerationRequest
>
    implements $QuestionnaireGenerationRequestCopyWith<$Res> {
  _$QuestionnaireGenerationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionnaireGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentFile = freezed,
    Object? documentName = null,
    Object? documentSize = null,
    Object? documentType = null,
    Object? questionType = null,
    Object? numberOfQuestions = null,
    Object? difficulty = null,
    Object? userId = null,
  }) {
    return _then(
      _value.copyWith(
            documentFile: freezed == documentFile
                ? _value.documentFile
                : documentFile // ignore: cast_nullable_to_non_nullable
                      as File?,
            documentName: null == documentName
                ? _value.documentName
                : documentName // ignore: cast_nullable_to_non_nullable
                      as String,
            documentSize: null == documentSize
                ? _value.documentSize
                : documentSize // ignore: cast_nullable_to_non_nullable
                      as int,
            documentType: null == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                      as String,
            questionType: null == questionType
                ? _value.questionType
                : questionType // ignore: cast_nullable_to_non_nullable
                      as QuestionType,
            numberOfQuestions: null == numberOfQuestions
                ? _value.numberOfQuestions
                : numberOfQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as QuestionDifficulty,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuestionnaireGenerationRequestImplCopyWith<$Res>
    implements $QuestionnaireGenerationRequestCopyWith<$Res> {
  factory _$$QuestionnaireGenerationRequestImplCopyWith(
    _$QuestionnaireGenerationRequestImpl value,
    $Res Function(_$QuestionnaireGenerationRequestImpl) then,
  ) = __$$QuestionnaireGenerationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeToJson: false, includeFromJson: false) File? documentFile,
    @JsonKey(name: 'document_name') String documentName,
    @JsonKey(name: 'document_size') int documentSize,
    @JsonKey(name: 'document_type') String documentType,
    @JsonKey(name: 'question_type') QuestionType questionType,
    @JsonKey(name: 'number_of_questions') int numberOfQuestions,
    QuestionDifficulty difficulty,
    @JsonKey(name: 'user_id') String userId,
  });
}

/// @nodoc
class __$$QuestionnaireGenerationRequestImplCopyWithImpl<$Res>
    extends
        _$QuestionnaireGenerationRequestCopyWithImpl<
          $Res,
          _$QuestionnaireGenerationRequestImpl
        >
    implements _$$QuestionnaireGenerationRequestImplCopyWith<$Res> {
  __$$QuestionnaireGenerationRequestImplCopyWithImpl(
    _$QuestionnaireGenerationRequestImpl _value,
    $Res Function(_$QuestionnaireGenerationRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuestionnaireGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentFile = freezed,
    Object? documentName = null,
    Object? documentSize = null,
    Object? documentType = null,
    Object? questionType = null,
    Object? numberOfQuestions = null,
    Object? difficulty = null,
    Object? userId = null,
  }) {
    return _then(
      _$QuestionnaireGenerationRequestImpl(
        documentFile: freezed == documentFile
            ? _value.documentFile
            : documentFile // ignore: cast_nullable_to_non_nullable
                  as File?,
        documentName: null == documentName
            ? _value.documentName
            : documentName // ignore: cast_nullable_to_non_nullable
                  as String,
        documentSize: null == documentSize
            ? _value.documentSize
            : documentSize // ignore: cast_nullable_to_non_nullable
                  as int,
        documentType: null == documentType
            ? _value.documentType
            : documentType // ignore: cast_nullable_to_non_nullable
                  as String,
        questionType: null == questionType
            ? _value.questionType
            : questionType // ignore: cast_nullable_to_non_nullable
                  as QuestionType,
        numberOfQuestions: null == numberOfQuestions
            ? _value.numberOfQuestions
            : numberOfQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as QuestionDifficulty,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireGenerationRequestImpl
    implements _QuestionnaireGenerationRequest {
  const _$QuestionnaireGenerationRequestImpl({
    @JsonKey(includeToJson: false, includeFromJson: false) this.documentFile,
    @JsonKey(name: 'document_name') required this.documentName,
    @JsonKey(name: 'document_size') required this.documentSize,
    @JsonKey(name: 'document_type') required this.documentType,
    @JsonKey(name: 'question_type') required this.questionType,
    @JsonKey(name: 'number_of_questions') required this.numberOfQuestions,
    required this.difficulty,
    @JsonKey(name: 'user_id') required this.userId,
  });

  factory _$QuestionnaireGenerationRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$QuestionnaireGenerationRequestImplFromJson(json);

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  final File? documentFile;
  @override
  @JsonKey(name: 'document_name')
  final String documentName;
  @override
  @JsonKey(name: 'document_size')
  final int documentSize;
  @override
  @JsonKey(name: 'document_type')
  final String documentType;
  @override
  @JsonKey(name: 'question_type')
  final QuestionType questionType;
  @override
  @JsonKey(name: 'number_of_questions')
  final int numberOfQuestions;
  @override
  final QuestionDifficulty difficulty;
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  @override
  String toString() {
    return 'QuestionnaireGenerationRequest(documentFile: $documentFile, documentName: $documentName, documentSize: $documentSize, documentType: $documentType, questionType: $questionType, numberOfQuestions: $numberOfQuestions, difficulty: $difficulty, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireGenerationRequestImpl &&
            (identical(other.documentFile, documentFile) ||
                other.documentFile == documentFile) &&
            (identical(other.documentName, documentName) ||
                other.documentName == documentName) &&
            (identical(other.documentSize, documentSize) ||
                other.documentSize == documentSize) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.numberOfQuestions, numberOfQuestions) ||
                other.numberOfQuestions == numberOfQuestions) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    documentFile,
    documentName,
    documentSize,
    documentType,
    questionType,
    numberOfQuestions,
    difficulty,
    userId,
  );

  /// Create a copy of QuestionnaireGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireGenerationRequestImplCopyWith<
    _$QuestionnaireGenerationRequestImpl
  >
  get copyWith =>
      __$$QuestionnaireGenerationRequestImplCopyWithImpl<
        _$QuestionnaireGenerationRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireGenerationRequestImplToJson(this);
  }
}

abstract class _QuestionnaireGenerationRequest
    implements QuestionnaireGenerationRequest {
  const factory _QuestionnaireGenerationRequest({
    @JsonKey(includeToJson: false, includeFromJson: false)
    final File? documentFile,
    @JsonKey(name: 'document_name') required final String documentName,
    @JsonKey(name: 'document_size') required final int documentSize,
    @JsonKey(name: 'document_type') required final String documentType,
    @JsonKey(name: 'question_type') required final QuestionType questionType,
    @JsonKey(name: 'number_of_questions') required final int numberOfQuestions,
    required final QuestionDifficulty difficulty,
    @JsonKey(name: 'user_id') required final String userId,
  }) = _$QuestionnaireGenerationRequestImpl;

  factory _QuestionnaireGenerationRequest.fromJson(Map<String, dynamic> json) =
      _$QuestionnaireGenerationRequestImpl.fromJson;

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  File? get documentFile;
  @override
  @JsonKey(name: 'document_name')
  String get documentName;
  @override
  @JsonKey(name: 'document_size')
  int get documentSize;
  @override
  @JsonKey(name: 'document_type')
  String get documentType;
  @override
  @JsonKey(name: 'question_type')
  QuestionType get questionType;
  @override
  @JsonKey(name: 'number_of_questions')
  int get numberOfQuestions;
  @override
  QuestionDifficulty get difficulty;
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// Create a copy of QuestionnaireGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionnaireGenerationRequestImplCopyWith<
    _$QuestionnaireGenerationRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
