class AudioModel {
  String pathFile;
  String title;
  String author;
  String youtubeUrl;
  String thumbnailUrl;

  AudioModel(
      {this.pathFile,
      this.title,
      this.author,
      this.youtubeUrl,
      this.thumbnailUrl});

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
