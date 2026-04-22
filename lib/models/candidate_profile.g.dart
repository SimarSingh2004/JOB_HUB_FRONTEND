// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'candidate_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EducationModelImpl _$$EducationModelImplFromJson(Map<String, dynamic> json) =>
    _$EducationModelImpl(
      institution: json['institution'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      field: json['field'] as String? ?? '',
      startYear: (json['startYear'] as num?)?.toInt(),
      endYear: (json['endYear'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EducationModelImplToJson(
  _$EducationModelImpl instance,
) => <String, dynamic>{
  'institution': instance.institution,
  'degree': instance.degree,
  'field': instance.field,
  'startYear': instance.startYear,
  'endYear': instance.endYear,
};

_$ExperienceModelImpl _$$ExperienceModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExperienceModelImpl(
  company: json['company'] as String? ?? '',
  role: json['role'] as String? ?? '',
  duration: json['duration'] as String? ?? '',
);

Map<String, dynamic> _$$ExperienceModelImplToJson(
  _$ExperienceModelImpl instance,
) => <String, dynamic>{
  'company': instance.company,
  'role': instance.role,
  'duration': instance.duration,
};

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );

Map<String, dynamic> _$$ProjectModelImplToJson(_$ProjectModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'link': instance.link,
    };

_$CandidateProfileModelImpl _$$CandidateProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$CandidateProfileModelImpl(
  id: json['_id'] as String,
  userId: json['userId'] as String,
  bio: json['bio'] as String? ?? '',
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  resume: json['resume'] as String? ?? '',
  education:
      (json['education'] as List<dynamic>?)
          ?.map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  experience:
      (json['experience'] as List<dynamic>?)
          ?.map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  projects:
      (json['projects'] as List<dynamic>?)
          ?.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CandidateProfileModelImplToJson(
  _$CandidateProfileModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.userId,
  'bio': instance.bio,
  'skills': instance.skills,
  'resume': instance.resume,
  'education': instance.education,
  'experience': instance.experience,
  'projects': instance.projects,
};
