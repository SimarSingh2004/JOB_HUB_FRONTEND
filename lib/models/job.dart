import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'job.freezed.dart';
part 'job.g.dart';

// recruiter comes back as a populated object on some endpoints (GET /jobs),
// but as a bare ObjectId string on others (POST /jobs create response),
// or missing entirely (application list, which only selects a few job fields).
// This normalizes all three cases instead of crashing on cast.
UserModel _recruiterFromJson(dynamic json) {
  if (json is Map<String, dynamic>) return UserModel.fromJson(json);
  if (json is String) {
    return UserModel(
      id: json,
      fullname: '',
      username: '',
      email: '',
      role: '',
      avatar: '',
    );
  }
  return const UserModel(
    id: '',
    fullname: '',
    username: '',
    email: '',
    role: '',
    avatar: '',
  );
}

@Freezed()
class JobModel with _$JobModel {
  const factory JobModel({
    @JsonKey(name: '_id') required String id,
    required String title,
    @Default('') String description,
    @Default([]) List<String> skillsRequired,
    double? salary,
    String? location,
    @JsonKey(fromJson: _recruiterFromJson) required UserModel recruiter,
    @Default(true) bool isActive,
    String? createdAt,
    @Default(false)
    bool hasApplied, // only meaningful for a logged-in candidate
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);
}
