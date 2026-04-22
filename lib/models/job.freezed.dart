// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JobModel _$JobModelFromJson(Map<String, dynamic> json) {
  return _JobModel.fromJson(json);
}

/// @nodoc
mixin _$JobModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get skillsRequired => throw _privateConstructorUsedError;
  double? get salary => throw _privateConstructorUsedError;
  String? get location =>
      throw _privateConstructorUsedError; // recruiter can be a full UserModel (when populated) or just an id string
  // We'll handle population carefully — for now store as UserModel
  UserModel get recruiter => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this JobModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobModelCopyWith<JobModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobModelCopyWith<$Res> {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) then) =
      _$JobModelCopyWithImpl<$Res, JobModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String description,
    List<String> skillsRequired,
    double? salary,
    String? location,
    UserModel recruiter,
    bool isActive,
    String? createdAt,
  });
}

/// @nodoc
class _$JobModelCopyWithImpl<$Res, $Val extends JobModel>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? skillsRequired = null,
    Object? salary = freezed,
    Object? location = freezed,
    Object? recruiter = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            skillsRequired: null == skillsRequired
                ? _value.skillsRequired
                : skillsRequired // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            salary: freezed == salary
                ? _value.salary
                : salary // ignore: cast_nullable_to_non_nullable
                      as double?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            recruiter: null == recruiter
                ? _value.recruiter
                : recruiter // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobModelImplCopyWith<$Res>
    implements $JobModelCopyWith<$Res> {
  factory _$$JobModelImplCopyWith(
    _$JobModelImpl value,
    $Res Function(_$JobModelImpl) then,
  ) = __$$JobModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String description,
    List<String> skillsRequired,
    double? salary,
    String? location,
    UserModel recruiter,
    bool isActive,
    String? createdAt,
  });
}

/// @nodoc
class __$$JobModelImplCopyWithImpl<$Res>
    extends _$JobModelCopyWithImpl<$Res, _$JobModelImpl>
    implements _$$JobModelImplCopyWith<$Res> {
  __$$JobModelImplCopyWithImpl(
    _$JobModelImpl _value,
    $Res Function(_$JobModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? skillsRequired = null,
    Object? salary = freezed,
    Object? location = freezed,
    Object? recruiter = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$JobModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        skillsRequired: null == skillsRequired
            ? _value._skillsRequired
            : skillsRequired // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        salary: freezed == salary
            ? _value.salary
            : salary // ignore: cast_nullable_to_non_nullable
                  as double?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        recruiter: null == recruiter
            ? _value.recruiter
            : recruiter // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobModelImpl implements _JobModel {
  const _$JobModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.title,
    required this.description,
    final List<String> skillsRequired = const [],
    this.salary,
    this.location,
    required this.recruiter,
    this.isActive = true,
    this.createdAt,
  }) : _skillsRequired = skillsRequired;

  factory _$JobModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String title;
  @override
  final String description;
  final List<String> _skillsRequired;
  @override
  @JsonKey()
  List<String> get skillsRequired {
    if (_skillsRequired is EqualUnmodifiableListView) return _skillsRequired;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsRequired);
  }

  @override
  final double? salary;
  @override
  final String? location;
  // recruiter can be a full UserModel (when populated) or just an id string
  // We'll handle population carefully — for now store as UserModel
  @override
  final UserModel recruiter;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'JobModel(id: $id, title: $title, description: $description, skillsRequired: $skillsRequired, salary: $salary, location: $location, recruiter: $recruiter, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._skillsRequired,
              _skillsRequired,
            ) &&
            (identical(other.salary, salary) || other.salary == salary) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.recruiter, recruiter) ||
                other.recruiter == recruiter) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    const DeepCollectionEquality().hash(_skillsRequired),
    salary,
    location,
    recruiter,
    isActive,
    createdAt,
  );

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      __$$JobModelImplCopyWithImpl<_$JobModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobModelImplToJson(this);
  }
}

abstract class _JobModel implements JobModel {
  const factory _JobModel({
    @JsonKey(name: '_id') required final String id,
    required final String title,
    required final String description,
    final List<String> skillsRequired,
    final double? salary,
    final String? location,
    required final UserModel recruiter,
    final bool isActive,
    final String? createdAt,
  }) = _$JobModelImpl;

  factory _JobModel.fromJson(Map<String, dynamic> json) =
      _$JobModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  List<String> get skillsRequired;
  @override
  double? get salary;
  @override
  String? get location; // recruiter can be a full UserModel (when populated) or just an id string
  // We'll handle population carefully — for now store as UserModel
  @override
  UserModel get recruiter;
  @override
  bool get isActive;
  @override
  String? get createdAt;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
