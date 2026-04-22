// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'recruiter_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecruiterProfileModelImpl _$$RecruiterProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$RecruiterProfileModelImpl(
  id: json['_id'] as String,
  userId: json['userId'] as String,
  companyName: json['companyName'] as String,
  companyDescription: json['companyDescription'] as String,
  companyWebsite: json['companyWebsite'] as String? ?? '',
  companyLogo: json['companyLogo'] as String? ?? '',
);

Map<String, dynamic> _$$RecruiterProfileModelImplToJson(
  _$RecruiterProfileModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.userId,
  'companyName': instance.companyName,
  'companyDescription': instance.companyDescription,
  'companyWebsite': instance.companyWebsite,
  'companyLogo': instance.companyLogo,
};
