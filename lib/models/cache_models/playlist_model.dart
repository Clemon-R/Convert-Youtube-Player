import 'package:convertyoutubeplayer/models/cache_models/audio_model.dart';

class PlaylistModel {
  String title;
  Map<String, AudioModel> musics;

  PlaylistModel({this.title, this.musics});

  PlaylistModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        musics = Map.fromIterable(
            (json['musics'] as List<dynamic>)
                .map((json) => AudioModel.fromJson(json))
                .toList(),
            key: (audio) => (audio as AudioModel).youtubeUrl,
            value: (value) => value);

  Map<String, dynamic> toJson() => {
        'title': title,
        'musics':
            musics.values.map((audio) => audio.toJson()).toList(growable: false)
      };
}
