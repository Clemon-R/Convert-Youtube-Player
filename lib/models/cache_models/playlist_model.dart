import 'package:json_annotation/json_annotation.dart';
import 'package:youtekmusic/models/cache_models/audio_model.dart';

part 'playlist_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaylistModel {
  String title;
  Map<String, AudioModel> musics;

  PlaylistModel({required this.title, required this.musics});

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    var result = _$PlaylistModelFromJson(json);
    result.musics.values.forEach((element) {
      element.playlist = result;
    });
    return result;
  }
  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
}
