class AudioModel {
  String pathFile;
  String title;
  String author;

  AudioModel({this.pathFile, this.title, this.author});

  AudioModel.fromJson(Map<String, dynamic> json)
      : pathFile = json['pathFile'],
        title = json['title'],
        author = json['author'];

  Map<String, dynamic> toJson() =>
      {'pathFile': pathFile, 'title': title, 'author': author};
}
