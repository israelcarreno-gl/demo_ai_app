// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuestionResponse {
  String get questionId => throw _privateConstructorUsedError;
  String get questionType =>
      throw _privateConstructorUsedError; // indices for selected options (0-based)
  List<int>? get selectedOptionIndices =>
      throw _privateConstructorUsedError; // free-text answer
  String? get answerText => throw _privateConstructorUsedError;

  /// Create a copy of QuestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionResponseCopyWith<QuestionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionResponseCopyWith<$Res> {
  factory $QuestionResponseCopyWith(
    QuestionResponse value,
    $Res Function(QuestionResponse) then,
  ) = _$QuestionResponseCopyWithImpl<$Res, QuestionResponse>;
  @useResult
  $Res call({
    String questionId,
    String questionType,
    List<int>? selectedOptionIndices,
    String? answerText,
  });
}

/// @nodoc
class _$QuestionResponseCopyWithImpl<$Res, $Val extends QuestionResponse>
    implements $QuestionResponseCopyWith<$Res> {
  _$QuestionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? questionType = null,
    Object? selectedOptionIndices = freezed,
    Object? answerText = freezed,
  }) {
    return _then(
      _value.copyWith(
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            questionType: null == questionType
                ? _value.questionType
                : questionType // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedOptionIndices: freezed == selectedOptionIndices
                ? _value.selectedOptionIndices
                : selectedOptionIndices // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            answerText: freezed == answerText
                ? _value.answerText
                : answerText // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuestionResponseImplCopyWith<$Res>
    implements $QuestionResponseCopyWith<$Res> {
  factory _$$QuestionResponseImplCopyWith(
    _$QuestionResponseImpl value,
    $Res Function(_$QuestionResponseImpl) then,
  ) = __$$QuestionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String questionId,
    String questionType,
    List<int>? selectedOptionIndices,
    String? answerText,
  });
}

/// @nodoc
class __$$QuestionResponseImplCopyWithImpl<$Res>
    extends _$QuestionResponseCopyWithImpl<$Res, _$QuestionResponseImpl>
    implements _$$QuestionResponseImplCopyWith<$Res> {
  __$$QuestionResponseImplCopyWithImpl(
    _$QuestionResponseImpl _value,
    $Res Function(_$QuestionResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? questionType = null,
    Object? selectedOptionIndices = freezed,
    Object? answerText = freezed,
  }) {
    return _then(
      _$QuestionResponseImpl(
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        questionType: null == questionType
            ? _value.questionType
            : questionType // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedOptionIndices: freezed == selectedOptionIndices
            ? _value._selectedOptionIndices
            : selectedOptionIndices // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        answerText: freezed == answerText
            ? _value.answerText
            : answerText // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$QuestionResponseImpl implements _QuestionResponse {
  const _$QuestionResponseImpl({
    required this.questionId,
    required this.questionType,
    final List<int>? selectedOptionIndices,
    this.answerText,
  }) : _selectedOptionIndices = selectedOptionIndices;

  @override
  final String questionId;
  @override
  final String questionType;
  // indices for selected options (0-based)
  final List<int>? _selectedOptionIndices;
  // indices for selected options (0-based)
  @override
  List<int>? get selectedOptionIndices {
    final value = _selectedOptionIndices;
    if (value == null) return null;
    if (_selectedOptionIndices is EqualUnmodifiableListView)
      return _selectedOptionIndices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // free-text answer
  @override
  final String? answerText;

  @override
  String toString() {
    return 'QuestionResponse(questionId: $questionId, questionType: $questionType, selectedOptionIndices: $selectedOptionIndices, answerText: $answerText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionResponseImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            const DeepCollectionEquality().equals(
              other._selectedOptionIndices,
              _selectedOptionIndices,
            ) &&
            (identical(other.answerText, answerText) ||
                other.answerText == answerText));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    questionId,
    questionType,
    const DeepCollectionEquality().hash(_selectedOptionIndices),
    answerText,
  );

  /// Create a copy of QuestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionResponseImplCopyWith<_$QuestionResponseImpl> get copyWith =>
      __$$QuestionResponseImplCopyWithImpl<_$QuestionResponseImpl>(
        this,
        _$identity,
      );
}

abstract class _QuestionResponse implements QuestionResponse {
  const factory _QuestionResponse({
    required final String questionId,
    required final String questionType,
    final List<int>? selectedOptionIndices,
    final String? answerText,
  }) = _$QuestionResponseImpl;

  @override
  String get questionId;
  @override
  String get questionType; // indices for selected options (0-based)
  @override
  List<int>? get selectedOptionIndices; // free-text answer
  @override
  String? get answerText;

  /// Create a copy of QuestionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionResponseImplCopyWith<_$QuestionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
