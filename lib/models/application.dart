import 'package:freezed_annotation/freezed_annotation.dart';
import 'job.dart';
// ignore: unused_import
import 'user.dart';

part 'application.freezed.dart';
part 'application.g.dart';

@freezed
class ApplicationModel with _$ApplicationModel {
  const factory ApplicationModel({
    @JsonKey(name: '_id') required String id,
    required JobModel job,
    // candidateData holds the populated candidate object when available
    @JsonKey(name: 'candidate') required dynamic candidateRaw,
    @Default('applied') String status,
    String? createdAt,
  }) = _ApplicationModel;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationModelFromJson(json);
}

// Extension to safely extract candidate display name
// whether candidate is a String (id) or a populated Map
extension ApplicationModelX on ApplicationModel {
  String get candidateDisplay {
    if (candidateRaw is Map) {
      final map = candidateRaw as Map<String, dynamic>;
      return map['fullname'] as String? ??
          map['username'] as String? ??
          'Unknown';
    }
    return candidateRaw.toString();
  }

  String get candidate => candidateDisplay;

  // The actual candidate ObjectId — needed anywhere an API call expects an
  // id (e.g. starting a chat). Do NOT confuse with `candidate` above, which
  // is a display name only.
  String get candidateId {
    if (candidateRaw is Map) {
      final map = candidateRaw as Map<String, dynamic>;
      return map['_id'] as String? ?? '';
    }
    return candidateRaw.toString();
  }
}
