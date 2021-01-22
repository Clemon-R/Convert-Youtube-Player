class AudioModel {
  String pathFile;
  String title;
  String author;
  String youtubeUrl;

  AudioModel({this.pathFile, this.title, this.author, this.youtubeUrl});

  AudioModel.fromJson(Map<String, dynamic> json)
      : pathFile = json['pathFile'],
        title = json['title'],
        author = json['author'],
        youtubeUrl = json['youtubeUrl'];

  Map<String, dynamic> toJson() => {
        'pathFile': pathFile,
        'title': title,
        'author': author,
        'youtubeUrl': youtubeUrl
      };
}
