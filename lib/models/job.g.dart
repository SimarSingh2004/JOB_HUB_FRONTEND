// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobModelImpl _$$JobModelImplFromJson(Map<String, dynamic> json) =>
    _$JobModelImpl(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      skillsRequired:
          (json['skillsRequired'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      salary: (json['salary'] as num?)?.toDouble(),
      location: json['location'] as String?,
      recruiter: UserModel.fromJson(json['recruiter'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'skillsRequired': instance.skillsRequired,
      'salary': instance.salary,
      'location': instance.location,
      'recruiter': instance.recruiter,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
    };
