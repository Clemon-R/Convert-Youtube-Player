import 'package:json_annotation/json_annotation.dart';
import 'package:youtekmusic/models/cache_models/playlist_model.dart';

part 'cache_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CacheModel {
  final Map<String, PlaylistModel> playlists;

  CacheModel({required this.playlists});

  factory CacheModel.fromJson(Map<String, dynamic> json) =>
      _$CacheModelFromJson(json);
  Map<String, dynamic> toJson() => _$CacheModelToJson(this);
}
