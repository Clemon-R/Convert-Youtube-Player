import 'package:convertyoutubeplayer/models/cache_models/playlist_model.dart';

class AudioModel {
  String pathFile;
  String title;
  String author;
  String youtubeUrl;
  String thumbnailUrl;

  PlaylistModel playlist;

  AudioModel(
      {this.pathFile,
      this.title,
      this.author,
      this.youtubeUrl,
      this.thumbnailUrl,
      this.playlist});

  AudioModel.fromJson(Map<String, dynamic> json)
      : pathFile = json['pathFile'],
        title = json['title'],
        author = json['author'],
        youtubeUrl = json['youtubeUrl'],
        thumbnailUrl = json['thumbnailUrl'];

  Map<String, dynamic> toJson() => {
        'pathFile': pathFile,
        'title': title,
        'author': author,
        'youtubeUrl': youtubeUrl,
        'thumbnailUrl': thumbnailUrl
      };
}
