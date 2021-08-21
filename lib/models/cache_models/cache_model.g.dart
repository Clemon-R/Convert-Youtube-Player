// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CacheModel _$CacheModelFromJson(Map<String, dynamic> json) {
  return CacheModel(
    playlists: (json['playlists'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, PlaylistModel.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$CacheModelToJson(CacheModel instance) =>
    <String, dynamic>{
      'playlists': instance.playlists.map((k, e) => MapEntry(k, e.toJson())),
    };
