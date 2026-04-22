// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruiter_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecruiterProfileModel _$RecruiterProfileModelFromJson(
  Map<String, dynamic> json,
) {
  return _RecruiterProfileModel.fromJson(json);
}

/// @nodoc
mixin _$RecruiterProfileModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get companyDescription => throw _privateConstructorUsedError;
  String get companyWebsite => throw _privateConstructorUsedError;
  String get companyLogo => throw _privateConstructorUsedError;

  /// Serializes this RecruiterProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecruiterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecruiterProfileModelCopyWith<RecruiterProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecruiterProfileModelCopyWith<$Res> {
  factory $RecruiterProfileModelCopyWith(
    RecruiterProfileModel value,
    $Res Function(RecruiterProfileModel) then,
  ) = _$RecruiterProfileModelCopyWithImpl<$Res, RecruiterProfileModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    String companyName,
    String companyDescription,
    String companyWebsite,
    String companyLogo,
  });
}

/// @nodoc
class _$RecruiterProfileModelCopyWithImpl<
  $Res,
  $Val extends RecruiterProfileModel
>
    implements $RecruiterProfileModelCopyWith<$Res> {
  _$RecruiterProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecruiterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? companyName = null,
    Object? companyDescription = null,
    Object? companyWebsite = null,
    Object? companyLogo = null,
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
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            companyDescription: null == companyDescription
                ? _value.companyDescription
                : companyDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            companyWebsite: null == companyWebsite
                ? _value.companyWebsite
                : companyWebsite // ignore: cast_nullable_to_non_nullable
                      as String,
            companyLogo: null == companyLogo
                ? _value.companyLogo
                : companyLogo // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecruiterProfileModelImplCopyWith<$Res>
    implements $RecruiterProfileModelCopyWith<$Res> {
  factory _$$RecruiterProfileModelImplCopyWith(
    _$RecruiterProfileModelImpl value,
    $Res Function(_$RecruiterProfileModelImpl) then,
  ) = __$$RecruiterProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    String companyName,
    String companyDescription,
    String companyWebsite,
    String companyLogo,
  });
}

/// @nodoc
class __$$RecruiterProfileModelImplCopyWithImpl<$Res>
    extends
        _$RecruiterProfileModelCopyWithImpl<$Res, _$RecruiterProfileModelImpl>
    implements _$$RecruiterProfileModelImplCopyWith<$Res> {
  __$$RecruiterProfileModelImplCopyWithImpl(
    _$RecruiterProfileModelImpl _value,
    $Res Function(_$RecruiterProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecruiterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? companyName = null,
    Object? companyDescription = null,
    Object? companyWebsite = null,
    Object? companyLogo = null,
  }) {
    return _then(
      _$RecruiterProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        companyDescription: null == companyDescription
            ? _value.companyDescription
            : companyDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        companyWebsite: null == companyWebsite
            ? _value.companyWebsite
            : companyWebsite // ignore: cast_nullable_to_non_nullable
                  as String,
        companyLogo: null == companyLogo
            ? _value.companyLogo
            : companyLogo // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecruiterProfileModelImpl implements _RecruiterProfileModel {
  const _$RecruiterProfileModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.userId,
    required this.companyName,
    required this.companyDescription,
    this.companyWebsite = '',
    this.companyLogo = '',
  });

  factory _$RecruiterProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecruiterProfileModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final String companyName;
  @override
  final String companyDescription;
  @override
  @JsonKey()
  final String companyWebsite;
  @override
  @JsonKey()
  final String companyLogo;

  @override
  String toString() {
    return 'RecruiterProfileModel(id: $id, userId: $userId, companyName: $companyName, companyDescription: $companyDescription, companyWebsite: $companyWebsite, companyLogo: $companyLogo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecruiterProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyDescription, companyDescription) ||
                other.companyDescription == companyDescription) &&
            (identical(other.companyWebsite, companyWebsite) ||
                other.companyWebsite == companyWebsite) &&
            (identical(other.companyLogo, companyLogo) ||
                other.companyLogo == companyLogo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    companyName,
    companyDescription,
    companyWebsite,
    companyLogo,
  );

  /// Create a copy of RecruiterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecruiterProfileModelImplCopyWith<_$RecruiterProfileModelImpl>
  get copyWith =>
      __$$RecruiterProfileModelImplCopyWithImpl<_$RecruiterProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecruiterProfileModelImplToJson(this);
  }
}

abstract class _RecruiterProfileModel implements RecruiterProfileModel {
  const factory _RecruiterProfileModel({
    @JsonKey(name: '_id') required final String id,
    required final String userId,
    required final String companyName,
    required final String companyDescription,
    final String companyWebsite,
    final String companyLogo,
  }) = _$RecruiterProfileModelImpl;

  factory _RecruiterProfileModel.fromJson(Map<String, dynamic> json) =
      _$RecruiterProfileModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  String get companyName;
  @override
  String get companyDescription;
  @override
  String get companyWebsite;
  @override
  String get companyLogo;

  /// Create a copy of RecruiterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecruiterProfileModelImplCopyWith<_$RecruiterProfileModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
