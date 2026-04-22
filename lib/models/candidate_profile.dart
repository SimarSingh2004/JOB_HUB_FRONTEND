import 'package:freezed_annotation/freezed_annotation.dart';

part 'candidate_profile.freezed.dart';
part 'candidate_profile.g.dart';

@Freezed()
class EducationModel with _$EducationModel {
  const factory EducationModel({
    @Default('') String institution,
    @Default('') String degree,
    @Default('') String field,
    int? startYear,
    int? endYear,
  }) = _EducationModel;

  factory EducationModel.fromJson(Map<String, dynamic> json) =>
      _$EducationModelFromJson(json);
}

@Freezed()
class ExperienceModel with _$ExperienceModel {
  const factory ExperienceModel({
    @Default('') String company,
    @Default('') String role,
    @Default('') String duration,
  }) = _ExperienceModel;

  factory ExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$ExperienceModelFromJson(json);
}

@Freezed()
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    @Default('') String title,
    @Default('') String description,
    @Default('') String link,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}

@Freezed()
class CandidateProfileModel with _$CandidateProfileModel {
  const factory CandidateProfileModel({
    @JsonKey(name: '_id') required String id,
    required String userId,
    @Default('') String bio,
    @Default([]) List<String> skills,
    @Default('') String resume,
    @Default([]) List<EducationModel> education,
    @Default([]) List<ExperienceModel> experience,
    @Default([]) List<ProjectModel> projects,
  }) = _CandidateProfileModel;

  factory CandidateProfileModel.fromJson(Map<String, dynamic> json) =>
      _$CandidateProfileModelFromJson(json);
}
