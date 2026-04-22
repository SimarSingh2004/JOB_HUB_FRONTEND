// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationModelImpl _$$ApplicationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationModelImpl(
  id: json['_id'] as String,
  job: JobModel.fromJson(json['job'] as Map<String, dynamic>),
  candidate: json['candidate'] as String,
  status: json['status'] as String? ?? 'applied',
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$$ApplicationModelImplToJson(
  _$ApplicationModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'job': instance.job,
  'candidate': instance.candidate,
  'status': instance.status,
  'createdAt': instance.createdAt,
};
