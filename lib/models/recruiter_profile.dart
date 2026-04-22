import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruiter_profile.freezed.dart';
part 'recruiter_profile.g.dart';

@Freezed()
class RecruiterProfileModel with _$RecruiterProfileModel {
  const factory RecruiterProfileModel({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required String companyName,
    required String companyDescription,
    @Default('') String companyWebsite,
    @Default('') String companyLogo,
  }) = _RecruiterProfileModel;

  factory RecruiterProfileModel.fromJson(Map<String, dynamic> json) =>
      _$RecruiterProfileModelFromJson(json);
}
