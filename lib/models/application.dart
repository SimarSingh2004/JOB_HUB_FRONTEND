import 'package:freezed_annotation/freezed_annotation.dart';
import 'job.dart';

part 'application.freezed.dart';
part 'application.g.dart';

// Maps to your application.model.js
// status enum: "applied" | "rejected" | "accepted" | "shortlisted" | "expired"
@Freezed()
class ApplicationModel with _$ApplicationModel {
  const factory ApplicationModel({
    @JsonKey(name: '_id') required String id,
    required JobModel job,
    required String candidate,
    @Default('applied') String status,
    String? createdAt,
  }) = _ApplicationModel;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationModelFromJson(json);
}
