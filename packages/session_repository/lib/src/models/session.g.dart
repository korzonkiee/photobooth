// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map json) => Session(
      id: json['id'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['created_at'] as Timestamp),
      prompt: json['prompt'] as String,
      photoUrls: (json['photo_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'prompt': instance.prompt,
      'photo_urls': instance.photoUrls,
    };
