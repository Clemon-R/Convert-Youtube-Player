// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioModel _$AudioModelFromJson(Map<String, dynamic> json) {
  return AudioModel(
    pathFile: json['pathFile'] as String,
    author: json['author'] as String?,
    title: json['title'] as String?,
    youtubeUrl: json['youtubeUrl'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String?,
  );
}

Map<String, dynamic> _$AudioModelToJson(AudioModel instance) =>
    <String, dynamic>{
      'pathFile': instance.pathFile,
      'title': instance.title,
      'author': instance.author,
      'youtubeUrl': instance.youtubeUrl,
      'thumbnailUrl': instance.thumbnailUrl,
    };
