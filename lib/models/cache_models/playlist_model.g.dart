// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) {
  return PlaylistModel(
    title: json['title'] as String,
    musics: (json['musics'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, AudioModel.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'musics': instance.musics.map((k, e) => MapEntry(k, e.toJson())),
    };
