import 'package:json_annotation/json_annotation.dart';
import 'package:youtekmusic/models/cache_models/playlist_model.dart';

part 'audio_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AudioModel {
  String pathFile;
  String title;
  String author;
  String youtubeUrl;
  String thumbnailUrl;

  PlaylistModel? playlist;

  AudioModel(
      {required this.pathFile,
      required this.author,
      required this.title,
      required this.youtubeUrl,
      required this.thumbnailUrl,
      this.playlist});

  factory AudioModel.fromJson(Map<String, dynamic> json) =>
      _$AudioModelFromJson(json);
  Map<String, dynamic> toJson() => _$AudioModelToJson(this);
}
