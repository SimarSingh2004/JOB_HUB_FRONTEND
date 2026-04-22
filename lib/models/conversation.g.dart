// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationModelImpl(
  id: json['_id'] as String,
  jobId: JobModel.fromJson(json['jobId'] as Map<String, dynamic>),
  candidateId: UserModel.fromJson(json['candidateId'] as Map<String, dynamic>),
  recruiterId: UserModel.fromJson(json['recruiterId'] as Map<String, dynamic>),
  lastMessage: json['lastMessage'] as String?,
  lastMessageAt: json['lastMessageAt'] as String?,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$$ConversationModelImplToJson(
  _$ConversationModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'jobId': instance.jobId,
  'candidateId': instance.candidateId,
  'recruiterId': instance.recruiterId,
  'lastMessage': instance.lastMessage,
  'lastMessageAt': instance.lastMessageAt,
  'isActive': instance.isActive,
};
