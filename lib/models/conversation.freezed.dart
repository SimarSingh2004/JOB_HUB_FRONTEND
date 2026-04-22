// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return _ConversationModel.fromJson(json);
}

/// @nodoc
mixin _$ConversationModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  JobModel get jobId =>
      throw _privateConstructorUsedError; // populated: has title
  UserModel get candidateId =>
      throw _privateConstructorUsedError; // populated: has fullname, email
  UserModel get recruiterId =>
      throw _privateConstructorUsedError; // populated: has fullname, email
  String? get lastMessage => throw _privateConstructorUsedError;
  String? get lastMessageAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
    ConversationModel value,
    $Res Function(ConversationModel) then,
  ) = _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    JobModel jobId,
    UserModel candidateId,
    UserModel recruiterId,
    String? lastMessage,
    String? lastMessageAt,
    bool isActive,
  });

  $JobModelCopyWith<$Res> get jobId;
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? candidateId = null,
    Object? recruiterId = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            jobId: null == jobId
                ? _value.jobId
                : jobId // ignore: cast_nullable_to_non_nullable
                      as JobModel,
            candidateId: null == candidateId
                ? _value.candidateId
                : candidateId // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            recruiterId: null == recruiterId
                ? _value.recruiterId
                : recruiterId // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            lastMessage: freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageAt: freezed == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JobModelCopyWith<$Res> get jobId {
    return $JobModelCopyWith<$Res>(_value.jobId, (value) {
      return _then(_value.copyWith(jobId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationModelImplCopyWith(
    _$ConversationModelImpl value,
    $Res Function(_$ConversationModelImpl) then,
  ) = __$$ConversationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    JobModel jobId,
    UserModel candidateId,
    UserModel recruiterId,
    String? lastMessage,
    String? lastMessageAt,
    bool isActive,
  });

  @override
  $JobModelCopyWith<$Res> get jobId;
}

/// @nodoc
class __$$ConversationModelImplCopyWithImpl<$Res>
    extends _$ConversationModelCopyWithImpl<$Res, _$ConversationModelImpl>
    implements _$$ConversationModelImplCopyWith<$Res> {
  __$$ConversationModelImplCopyWithImpl(
    _$ConversationModelImpl _value,
    $Res Function(_$ConversationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? candidateId = null,
    Object? recruiterId = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$ConversationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        jobId: null == jobId
            ? _value.jobId
            : jobId // ignore: cast_nullable_to_non_nullable
                  as JobModel,
        candidateId: null == candidateId
            ? _value.candidateId
            : candidateId // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        recruiterId: null == recruiterId
            ? _value.recruiterId
            : recruiterId // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        lastMessage: freezed == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageAt: freezed == lastMessageAt
            ? _value.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationModelImpl implements _ConversationModel {
  const _$ConversationModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.jobId,
    required this.candidateId,
    required this.recruiterId,
    this.lastMessage,
    this.lastMessageAt,
    this.isActive = true,
  });

  factory _$ConversationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final JobModel jobId;
  // populated: has title
  @override
  final UserModel candidateId;
  // populated: has fullname, email
  @override
  final UserModel recruiterId;
  // populated: has fullname, email
  @override
  final String? lastMessage;
  @override
  final String? lastMessageAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'ConversationModel(id: $id, jobId: $jobId, candidateId: $candidateId, recruiterId: $recruiterId, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.candidateId, candidateId) ||
                other.candidateId == candidateId) &&
            (identical(other.recruiterId, recruiterId) ||
                other.recruiterId == recruiterId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    jobId,
    candidateId,
    recruiterId,
    lastMessage,
    lastMessageAt,
    isActive,
  );

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      __$$ConversationModelImplCopyWithImpl<_$ConversationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationModelImplToJson(this);
  }
}

abstract class _ConversationModel implements ConversationModel {
  const factory _ConversationModel({
    @JsonKey(name: '_id') required final String id,
    required final JobModel jobId,
    required final UserModel candidateId,
    required final UserModel recruiterId,
    final String? lastMessage,
    final String? lastMessageAt,
    final bool isActive,
  }) = _$ConversationModelImpl;

  factory _ConversationModel.fromJson(Map<String, dynamic> json) =
      _$ConversationModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  JobModel get jobId; // populated: has title
  @override
  UserModel get candidateId; // populated: has fullname, email
  @override
  UserModel get recruiterId; // populated: has fullname, email
  @override
  String? get lastMessage;
  @override
  String? get lastMessageAt;
  @override
  bool get isActive;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
