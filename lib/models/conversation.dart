import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';
import 'job.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@Freezed()
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    @JsonKey(name: '_id') required String id,
    required JobModel jobId, // populated: has title
    required UserModel candidateId, // populated: has fullname, email
    required UserModel recruiterId, // populated: has fullname, email
    String? lastMessage,
    String? lastMessageAt,
    @Default(true) bool isActive,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}
