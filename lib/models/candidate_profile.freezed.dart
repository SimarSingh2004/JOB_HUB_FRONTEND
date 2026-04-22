// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candidate_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EducationModel _$EducationModelFromJson(Map<String, dynamic> json) {
  return _EducationModel.fromJson(json);
}

/// @nodoc
mixin _$EducationModel {
  String get institution => throw _privateConstructorUsedError;
  String get degree => throw _privateConstructorUsedError;
  String get field => throw _privateConstructorUsedError;
  int? get startYear => throw _privateConstructorUsedError;
  int? get endYear => throw _privateConstructorUsedError;

  /// Serializes this EducationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EducationModelCopyWith<EducationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EducationModelCopyWith<$Res> {
  factory $EducationModelCopyWith(
    EducationModel value,
    $Res Function(EducationModel) then,
  ) = _$EducationModelCopyWithImpl<$Res, EducationModel>;
  @useResult
  $Res call({
    String institution,
    String degree,
    String field,
    int? startYear,
    int? endYear,
  });
}

/// @nodoc
class _$EducationModelCopyWithImpl<$Res, $Val extends EducationModel>
    implements $EducationModelCopyWith<$Res> {
  _$EducationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? institution = null,
    Object? degree = null,
    Object? field = null,
    Object? startYear = freezed,
    Object? endYear = freezed,
  }) {
    return _then(
      _value.copyWith(
            institution: null == institution
                ? _value.institution
                : institution // ignore: cast_nullable_to_non_nullable
                      as String,
            degree: null == degree
                ? _value.degree
                : degree // ignore: cast_nullable_to_non_nullable
                      as String,
            field: null == field
                ? _value.field
                : field // ignore: cast_nullable_to_non_nullable
                      as String,
            startYear: freezed == startYear
                ? _value.startYear
                : startYear // ignore: cast_nullable_to_non_nullable
                      as int?,
            endYear: freezed == endYear
                ? _value.endYear
                : endYear // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EducationModelImplCopyWith<$Res>
    implements $EducationModelCopyWith<$Res> {
  factory _$$EducationModelImplCopyWith(
    _$EducationModelImpl value,
    $Res Function(_$EducationModelImpl) then,
  ) = __$$EducationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String institution,
    String degree,
    String field,
    int? startYear,
    int? endYear,
  });
}

/// @nodoc
class __$$EducationModelImplCopyWithImpl<$Res>
    extends _$EducationModelCopyWithImpl<$Res, _$EducationModelImpl>
    implements _$$EducationModelImplCopyWith<$Res> {
  __$$EducationModelImplCopyWithImpl(
    _$EducationModelImpl _value,
    $Res Function(_$EducationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? institution = null,
    Object? degree = null,
    Object? field = null,
    Object? startYear = freezed,
    Object? endYear = freezed,
  }) {
    return _then(
      _$EducationModelImpl(
        institution: null == institution
            ? _value.institution
            : institution // ignore: cast_nullable_to_non_nullable
                  as String,
        degree: null == degree
            ? _value.degree
            : degree // ignore: cast_nullable_to_non_nullable
                  as String,
        field: null == field
            ? _value.field
            : field // ignore: cast_nullable_to_non_nullable
                  as String,
        startYear: freezed == startYear
            ? _value.startYear
            : startYear // ignore: cast_nullable_to_non_nullable
                  as int?,
        endYear: freezed == endYear
            ? _value.endYear
            : endYear // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EducationModelImpl implements _EducationModel {
  const _$EducationModelImpl({
    this.institution = '',
    this.degree = '',
    this.field = '',
    this.startYear,
    this.endYear,
  });

  factory _$EducationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EducationModelImplFromJson(json);

  @override
  @JsonKey()
  final String institution;
  @override
  @JsonKey()
  final String degree;
  @override
  @JsonKey()
  final String field;
  @override
  final int? startYear;
  @override
  final int? endYear;

  @override
  String toString() {
    return 'EducationModel(institution: $institution, degree: $degree, field: $field, startYear: $startYear, endYear: $endYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EducationModelImpl &&
            (identical(other.institution, institution) ||
                other.institution == institution) &&
            (identical(other.degree, degree) || other.degree == degree) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.startYear, startYear) ||
                other.startYear == startYear) &&
            (identical(other.endYear, endYear) || other.endYear == endYear));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, institution, degree, field, startYear, endYear);

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EducationModelImplCopyWith<_$EducationModelImpl> get copyWith =>
      __$$EducationModelImplCopyWithImpl<_$EducationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EducationModelImplToJson(this);
  }
}

abstract class _EducationModel implements EducationModel {
  const factory _EducationModel({
    final String institution,
    final String degree,
    final String field,
    final int? startYear,
    final int? endYear,
  }) = _$EducationModelImpl;

  factory _EducationModel.fromJson(Map<String, dynamic> json) =
      _$EducationModelImpl.fromJson;

  @override
  String get institution;
  @override
  String get degree;
  @override
  String get field;
  @override
  int? get startYear;
  @override
  int? get endYear;

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EducationModelImplCopyWith<_$EducationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExperienceModel _$ExperienceModelFromJson(Map<String, dynamic> json) {
  return _ExperienceModel.fromJson(json);
}

/// @nodoc
mixin _$ExperienceModel {
  String get company => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get duration => throw _privateConstructorUsedError;

  /// Serializes this ExperienceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExperienceModelCopyWith<ExperienceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExperienceModelCopyWith<$Res> {
  factory $ExperienceModelCopyWith(
    ExperienceModel value,
    $Res Function(ExperienceModel) then,
  ) = _$ExperienceModelCopyWithImpl<$Res, ExperienceModel>;
  @useResult
  $Res call({String company, String role, String duration});
}

/// @nodoc
class _$ExperienceModelCopyWithImpl<$Res, $Val extends ExperienceModel>
    implements $ExperienceModelCopyWith<$Res> {
  _$ExperienceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? company = null,
    Object? role = null,
    Object? duration = null,
  }) {
    return _then(
      _value.copyWith(
            company: null == company
                ? _value.company
                : company // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExperienceModelImplCopyWith<$Res>
    implements $ExperienceModelCopyWith<$Res> {
  factory _$$ExperienceModelImplCopyWith(
    _$ExperienceModelImpl value,
    $Res Function(_$ExperienceModelImpl) then,
  ) = __$$ExperienceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String company, String role, String duration});
}

/// @nodoc
class __$$ExperienceModelImplCopyWithImpl<$Res>
    extends _$ExperienceModelCopyWithImpl<$Res, _$ExperienceModelImpl>
    implements _$$ExperienceModelImplCopyWith<$Res> {
  __$$ExperienceModelImplCopyWithImpl(
    _$ExperienceModelImpl _value,
    $Res Function(_$ExperienceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? company = null,
    Object? role = null,
    Object? duration = null,
  }) {
    return _then(
      _$ExperienceModelImpl(
        company: null == company
            ? _value.company
            : company // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExperienceModelImpl implements _ExperienceModel {
  const _$ExperienceModelImpl({
    this.company = '',
    this.role = '',
    this.duration = '',
  });

  factory _$ExperienceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExperienceModelImplFromJson(json);

  @override
  @JsonKey()
  final String company;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey()
  final String duration;

  @override
  String toString() {
    return 'ExperienceModel(company: $company, role: $role, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExperienceModelImpl &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, company, role, duration);

  /// Create a copy of ExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExperienceModelImplCopyWith<_$ExperienceModelImpl> get copyWith =>
      __$$ExperienceModelImplCopyWithImpl<_$ExperienceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExperienceModelImplToJson(this);
  }
}

abstract class _ExperienceModel implements ExperienceModel {
  const factory _ExperienceModel({
    final String company,
    final String role,
    final String duration,
  }) = _$ExperienceModelImpl;

  factory _ExperienceModel.fromJson(Map<String, dynamic> json) =
      _$ExperienceModelImpl.fromJson;

  @override
  String get company;
  @override
  String get role;
  @override
  String get duration;

  /// Create a copy of ExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExperienceModelImplCopyWith<_$ExperienceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return _ProjectModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectModel {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectModelCopyWith<ProjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectModelCopyWith<$Res> {
  factory $ProjectModelCopyWith(
    ProjectModel value,
    $Res Function(ProjectModel) then,
  ) = _$ProjectModelCopyWithImpl<$Res, ProjectModel>;
  @useResult
  $Res call({String title, String description, String link});
}

/// @nodoc
class _$ProjectModelCopyWithImpl<$Res, $Val extends ProjectModel>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? link = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            link: null == link
                ? _value.link
                : link // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectModelImplCopyWith<$Res>
    implements $ProjectModelCopyWith<$Res> {
  factory _$$ProjectModelImplCopyWith(
    _$ProjectModelImpl value,
    $Res Function(_$ProjectModelImpl) then,
  ) = __$$ProjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description, String link});
}

/// @nodoc
class __$$ProjectModelImplCopyWithImpl<$Res>
    extends _$ProjectModelCopyWithImpl<$Res, _$ProjectModelImpl>
    implements _$$ProjectModelImplCopyWith<$Res> {
  __$$ProjectModelImplCopyWithImpl(
    _$ProjectModelImpl _value,
    $Res Function(_$ProjectModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? link = null,
  }) {
    return _then(
      _$ProjectModelImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        link: null == link
            ? _value.link
            : link // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectModelImpl implements _ProjectModel {
  const _$ProjectModelImpl({
    this.title = '',
    this.description = '',
    this.link = '',
  });

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String link;

  @override
  String toString() {
    return 'ProjectModel(title: $title, description: $description, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.link, link) || other.link == link));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, link);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      __$$ProjectModelImplCopyWithImpl<_$ProjectModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectModelImplToJson(this);
  }
}

abstract class _ProjectModel implements ProjectModel {
  const factory _ProjectModel({
    final String title,
    final String description,
    final String link,
  }) = _$ProjectModelImpl;

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  String get link;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CandidateProfileModel _$CandidateProfileModelFromJson(
  Map<String, dynamic> json,
) {
  return _CandidateProfileModel.fromJson(json);
}

/// @nodoc
mixin _$CandidateProfileModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  String get resume => throw _privateConstructorUsedError;
  List<EducationModel> get education => throw _privateConstructorUsedError;
  List<ExperienceModel> get experience => throw _privateConstructorUsedError;
  List<ProjectModel> get projects => throw _privateConstructorUsedError;

  /// Serializes this CandidateProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CandidateProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandidateProfileModelCopyWith<CandidateProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidateProfileModelCopyWith<$Res> {
  factory $CandidateProfileModelCopyWith(
    CandidateProfileModel value,
    $Res Function(CandidateProfileModel) then,
  ) = _$CandidateProfileModelCopyWithImpl<$Res, CandidateProfileModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    String bio,
    List<String> skills,
    String resume,
    List<EducationModel> education,
    List<ExperienceModel> experience,
    List<ProjectModel> projects,
  });
}

/// @nodoc
class _$CandidateProfileModelCopyWithImpl<
  $Res,
  $Val extends CandidateProfileModel
>
    implements $CandidateProfileModelCopyWith<$Res> {
  _$CandidateProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandidateProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bio = null,
    Object? skills = null,
    Object? resume = null,
    Object? education = null,
    Object? experience = null,
    Object? projects = null,
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
            bio: null == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String,
            skills: null == skills
                ? _value.skills
                : skills // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            resume: null == resume
                ? _value.resume
                : resume // ignore: cast_nullable_to_non_nullable
                      as String,
            education: null == education
                ? _value.education
                : education // ignore: cast_nullable_to_non_nullable
                      as List<EducationModel>,
            experience: null == experience
                ? _value.experience
                : experience // ignore: cast_nullable_to_non_nullable
                      as List<ExperienceModel>,
            projects: null == projects
                ? _value.projects
                : projects // ignore: cast_nullable_to_non_nullable
                      as List<ProjectModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CandidateProfileModelImplCopyWith<$Res>
    implements $CandidateProfileModelCopyWith<$Res> {
  factory _$$CandidateProfileModelImplCopyWith(
    _$CandidateProfileModelImpl value,
    $Res Function(_$CandidateProfileModelImpl) then,
  ) = __$$CandidateProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String userId,
    String bio,
    List<String> skills,
    String resume,
    List<EducationModel> education,
    List<ExperienceModel> experience,
    List<ProjectModel> projects,
  });
}

/// @nodoc
class __$$CandidateProfileModelImplCopyWithImpl<$Res>
    extends
        _$CandidateProfileModelCopyWithImpl<$Res, _$CandidateProfileModelImpl>
    implements _$$CandidateProfileModelImplCopyWith<$Res> {
  __$$CandidateProfileModelImplCopyWithImpl(
    _$CandidateProfileModelImpl _value,
    $Res Function(_$CandidateProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CandidateProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bio = null,
    Object? skills = null,
    Object? resume = null,
    Object? education = null,
    Object? experience = null,
    Object? projects = null,
  }) {
    return _then(
      _$CandidateProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: null == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String,
        skills: null == skills
            ? _value._skills
            : skills // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        resume: null == resume
            ? _value.resume
            : resume // ignore: cast_nullable_to_non_nullable
                  as String,
        education: null == education
            ? _value._education
            : education // ignore: cast_nullable_to_non_nullable
                  as List<EducationModel>,
        experience: null == experience
            ? _value._experience
            : experience // ignore: cast_nullable_to_non_nullable
                  as List<ExperienceModel>,
        projects: null == projects
            ? _value._projects
            : projects // ignore: cast_nullable_to_non_nullable
                  as List<ProjectModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CandidateProfileModelImpl implements _CandidateProfileModel {
  const _$CandidateProfileModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.userId,
    this.bio = '',
    final List<String> skills = const [],
    this.resume = '',
    final List<EducationModel> education = const [],
    final List<ExperienceModel> experience = const [],
    final List<ProjectModel> projects = const [],
  }) : _skills = skills,
       _education = education,
       _experience = experience,
       _projects = projects;

  factory _$CandidateProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CandidateProfileModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  @JsonKey()
  final String bio;
  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  @JsonKey()
  final String resume;
  final List<EducationModel> _education;
  @override
  @JsonKey()
  List<EducationModel> get education {
    if (_education is EqualUnmodifiableListView) return _education;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_education);
  }

  final List<ExperienceModel> _experience;
  @override
  @JsonKey()
  List<ExperienceModel> get experience {
    if (_experience is EqualUnmodifiableListView) return _experience;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_experience);
  }

  final List<ProjectModel> _projects;
  @override
  @JsonKey()
  List<ProjectModel> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  @override
  String toString() {
    return 'CandidateProfileModel(id: $id, userId: $userId, bio: $bio, skills: $skills, resume: $resume, education: $education, experience: $experience, projects: $projects)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandidateProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.resume, resume) || other.resume == resume) &&
            const DeepCollectionEquality().equals(
              other._education,
              _education,
            ) &&
            const DeepCollectionEquality().equals(
              other._experience,
              _experience,
            ) &&
            const DeepCollectionEquality().equals(other._projects, _projects));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    bio,
    const DeepCollectionEquality().hash(_skills),
    resume,
    const DeepCollectionEquality().hash(_education),
    const DeepCollectionEquality().hash(_experience),
    const DeepCollectionEquality().hash(_projects),
  );

  /// Create a copy of CandidateProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandidateProfileModelImplCopyWith<_$CandidateProfileModelImpl>
  get copyWith =>
      __$$CandidateProfileModelImplCopyWithImpl<_$CandidateProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CandidateProfileModelImplToJson(this);
  }
}

abstract class _CandidateProfileModel implements CandidateProfileModel {
  const factory _CandidateProfileModel({
    @JsonKey(name: '_id') required final String id,
    required final String userId,
    final String bio,
    final List<String> skills,
    final String resume,
    final List<EducationModel> education,
    final List<ExperienceModel> experience,
    final List<ProjectModel> projects,
  }) = _$CandidateProfileModelImpl;

  factory _CandidateProfileModel.fromJson(Map<String, dynamic> json) =
      _$CandidateProfileModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  String get bio;
  @override
  List<String> get skills;
  @override
  String get resume;
  @override
  List<EducationModel> get education;
  @override
  List<ExperienceModel> get experience;
  @override
  List<ProjectModel> get projects;

  /// Create a copy of CandidateProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandidateProfileModelImplCopyWith<_$CandidateProfileModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
