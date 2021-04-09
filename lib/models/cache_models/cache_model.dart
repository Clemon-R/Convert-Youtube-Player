import 'package:convertyoutubeplayer/models/cache_models/playlist_model.dart';

class CacheModel {
  Map<String?, PlaylistModel?> playlists = Map();

  CacheModel();

  CacheModel.fromJson(Map<String, dynamic> json)
      : playlists = json['playlists'] != null
            ? Map.fromIterable(
                (json['playlists'] as List<dynamic>)
                    .map((json) => PlaylistModel.fromJson(json))
                    .toList(),
                key: (playlist) => (playlist as PlaylistModel).title,
                value: (value) => value)
            : Map();

  Map<String, dynamic> toJson() => {
        'playlists': playlists.values
            .map((playlist) => playlist!.toJson())
            .toList(growable: false)
      };
}
