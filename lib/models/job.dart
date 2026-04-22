import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@Freezed()
class JobModel with _$JobModel {
  const factory JobModel({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String description,
    @Default([]) List<String> skillsRequired,
    double? salary,
    String? location,
    // recruiter can be a full UserModel (when populated) or just an id string
    // We'll handle population carefully — for now store as UserModel
    required UserModel recruiter,
    @Default(true) bool isActive,
    String? createdAt,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);
}
