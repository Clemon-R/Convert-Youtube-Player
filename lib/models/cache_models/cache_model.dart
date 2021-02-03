import 'package:convertyoutubeplayer/models/cache_models/playlist_model.dart';

import 'audio_model.dart';

class CacheModel {
  Map<String, AudioModel> audios = Map();
  Map<String, PlaylistModel> playlists = Map();

  CacheModel();

  CacheModel.fromJson(Map<String, dynamic> json)
      : audios = json['audios'] != null
            ? Map.fromIterable(
                (json['audios'] as List<dynamic>)
                    .map((json) => AudioModel.fromJson(json))
                    .toList(),
                key: (audio) => (audio as AudioModel).youtubeUrl,
                value: (value) => value)
            : Map(),
        playlists = json['playlists'] != null
            ? Map.fromIterable(
                (json['playlists'] as List<dynamic>)
                    .map((json) => PlaylistModel.fromJson(json))
                    .toList(),
                key: (playlist) => (playlist as PlaylistModel).title,
                value: (value) => value)
            : Map();

  Map<String, dynamic> toJson() => {
        'audios': audios.values
            .map((audio) => audio.toJson())
            .toList(growable: false),
        'playlists': playlists.values
            .map((playlist) => playlist.toJson())
            .toList(growable: false)
      };
}
