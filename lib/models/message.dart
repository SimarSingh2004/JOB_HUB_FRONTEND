import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@Freezed()
class MessageModel with _$MessageModel {
  const factory MessageModel({
    @JsonKey(name: '_id') required String id,
    required String conversationId,
    required String senderId,
    required String text,
    String? createdAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
