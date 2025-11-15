// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuestionnaireModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get documentName => throw _privateConstructorUsedError;
  String? get documentPath => throw _privateConstructorUsedError;
  int? get documentSize => throw _privateConstructorUsedError;
  String? get documentType => throw _privateConstructorUsedError;
  List<QuestionModel>? get questions => throw _privateConstructorUsedError;
  double? get accuracy => throw _privateConstructorUsedError;
  int? get completionTime => throw _privateConstructorUsedError;
  int? get estimatedTime => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;

  /// Create a copy of QuestionnaireModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionnaireModelCopyWith<QuestionnaireModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireModelCopyWith<$Res> {
  factory $QuestionnaireModelCopyWith(
    QuestionnaireModel value,
    $Res Function(QuestionnaireModel) then,
  ) = _$QuestionnaireModelCopyWithImpl<$Res, QuestionnaireModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    DateTime createdAt,
    DateTime? updatedAt,
    String? description,
    String status,
    String? documentName,
    String? documentPath,
    int? documentSize,
    String? documentType,
    List<QuestionModel>? questions,
    double? accuracy,
    int? completionTime,
    int? estimatedTime,
    String? summary,
  });
}

/// @nodoc
class _$QuestionnaireModelCopyWithImpl<$Res, $Val extends QuestionnaireModel>
    implements $QuestionnaireModelCopyWith<$Res> {
  _$QuestionnaireModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionnaireModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? description = freezed,
    Object? status = null,
    Object? documentName = freezed,
    Object? documentPath = freezed,
    Object? documentSize = freezed,
    Object? documentType = freezed,
    Object? questions = freezed,
    Object? accuracy = freezed,
    Object? completionTime = freezed,
    Object? estimatedTime = freezed,
    Object? summary = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            documentName: freezed == documentName
                ? _value.documentName
                : documentName // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentPath: freezed == documentPath
                ? _value.documentPath
                : documentPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentSize: freezed == documentSize
                ? _value.documentSize
                : documentSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            documentType: freezed == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                      as String?,
            questions: freezed == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<QuestionModel>?,
            accuracy: freezed == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double?,
            completionTime: freezed == completionTime
                ? _value.completionTime
                : completionTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            estimatedTime: freezed == estimatedTime
                ? _value.estimatedTime
                : estimatedTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            summary: freezed == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuestionnaireModelImplCopyWith<$Res>
    implements $QuestionnaireModelCopyWith<$Res> {
  factory _$$QuestionnaireModelImplCopyWith(
    _$QuestionnaireModelImpl value,
    $Res Function(_$QuestionnaireModelImpl) then,
  ) = __$$QuestionnaireModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    DateTime createdAt,
    DateTime? updatedAt,
    String? description,
    String status,
    String? documentName,
    String? documentPath,
    int? documentSize,
    String? documentType,
    List<QuestionModel>? questions,
    double? accuracy,
    int? completionTime,
    int? estimatedTime,
    String? summary,
  });
}

/// @nodoc
class __$$QuestionnaireModelImplCopyWithImpl<$Res>
    extends _$QuestionnaireModelCopyWithImpl<$Res, _$QuestionnaireModelImpl>
    implements _$$QuestionnaireModelImplCopyWith<$Res> {
  __$$QuestionnaireModelImplCopyWithImpl(
    _$QuestionnaireModelImpl _value,
    $Res Function(_$QuestionnaireModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuestionnaireModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? description = freezed,
    Object? status = null,
    Object? documentName = freezed,
    Object? documentPath = freezed,
    Object? documentSize = freezed,
    Object? documentType = freezed,
    Object? questions = freezed,
    Object? accuracy = freezed,
    Object? completionTime = freezed,
    Object? estimatedTime = freezed,
    Object? summary = freezed,
  }) {
    return _then(
      _$QuestionnaireModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        documentName: freezed == documentName
            ? _value.documentName
            : documentName // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentPath: freezed == documentPath
            ? _value.documentPath
            : documentPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentSize: freezed == documentSize
            ? _value.documentSize
            : documentSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        documentType: freezed == documentType
            ? _value.documentType
            : documentType // ignore: cast_nullable_to_non_nullable
                  as String?,
        questions: freezed == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<QuestionModel>?,
        accuracy: freezed == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double?,
        completionTime: freezed == completionTime
            ? _value.completionTime
            : completionTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        estimatedTime: freezed == estimatedTime
            ? _value.estimatedTime
            : estimatedTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        summary: freezed == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$QuestionnaireModelImpl extends _QuestionnaireModel {
  const _$QuestionnaireModelImpl({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    this.updatedAt,
    this.description,
    this.status = 'draft',
    this.documentName,
    this.documentPath,
    this.documentSize,
    this.documentType,
    final List<QuestionModel>? questions,
    this.accuracy,
    this.completionTime,
    this.estimatedTime,
    this.summary,
  }) : _questions = questions,
       super._();

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? description;
  @override
  @JsonKey()
  final String status;
  @override
  final String? documentName;
  @override
  final String? documentPath;
  @override
  final int? documentSize;
  @override
  final String? documentType;
  final List<QuestionModel>? _questions;
  @override
  List<QuestionModel>? get questions {
    final value = _questions;
    if (value == null) return null;
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? accuracy;
  @override
  final int? completionTime;
  @override
  final int? estimatedTime;
  @override
  final String? summary;

  @override
  String toString() {
    return 'QuestionnaireModel(id: $id, userId: $userId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, status: $status, documentName: $documentName, documentPath: $documentPath, documentSize: $documentSize, documentType: $documentType, questions: $questions, accuracy: $accuracy, completionTime: $completionTime, estimatedTime: $estimatedTime, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.documentName, documentName) ||
                other.documentName == documentName) &&
            (identical(other.documentPath, documentPath) ||
                other.documentPath == documentPath) &&
            (identical(other.documentSize, documentSize) ||
                other.documentSize == documentSize) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.completionTime, completionTime) ||
                other.completionTime == completionTime) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    title,
    createdAt,
    updatedAt,
    description,
    status,
    documentName,
    documentPath,
    documentSize,
    documentType,
    const DeepCollectionEquality().hash(_questions),
    accuracy,
    completionTime,
    estimatedTime,
    summary,
  );

  /// Create a copy of QuestionnaireModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireModelImplCopyWith<_$QuestionnaireModelImpl> get copyWith =>
      __$$QuestionnaireModelImplCopyWithImpl<_$QuestionnaireModelImpl>(
        this,
        _$identity,
      );
}

abstract class _QuestionnaireModel extends QuestionnaireModel {
  const factory _QuestionnaireModel({
    required final String id,
    required final String userId,
    required final String title,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final String? description,
    final String status,
    final String? documentName,
    final String? documentPath,
    final int? documentSize,
    final String? documentType,
    final List<QuestionModel>? questions,
    final double? accuracy,
    final int? completionTime,
    final int? estimatedTime,
    final String? summary,
  }) = _$QuestionnaireModelImpl;
  const _QuestionnaireModel._() : super._();

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get description;
  @override
  String get status;
  @override
  String? get documentName;
  @override
  String? get documentPath;
  @override
  int? get documentSize;
  @override
  String? get documentType;
  @override
  List<QuestionModel>? get questions;
  @override
  double? get accuracy;
  @override
  int? get completionTime;
  @override
  int? get estimatedTime;
  @override
  String? get summary;

  /// Create a copy of QuestionnaireModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionnaireModelImplCopyWith<_$QuestionnaireModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
