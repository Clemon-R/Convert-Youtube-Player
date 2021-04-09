// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_convert_music_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartConvertMusicRestModel _$StartConvertMusicRestModelFromJson(
    Map<String, dynamic> json) {
  return StartConvertMusicRestModel(
    url: json['url'] as String,
    extension: json['extension'] as String,
  );
}

Map<String, dynamic> _$StartConvertMusicRestModelToJson(
        StartConvertMusicRestModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'extension': instance.extension,
    };
