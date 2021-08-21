import 'package:json_annotation/json_annotation.dart';

import '../irest_model.dart';

part "start_convert_music_request_model.g.dart";

@JsonSerializable(explicitToJson: true)
class StartConvertMusicRestModel extends IRestModel {
  String url;
  String extension;

  StartConvertMusicRestModel({required this.url, required this.extension});

  factory StartConvertMusicRestModel.fromJson(Map<String, dynamic> json) =>
      _$StartConvertMusicRestModelFromJson(json);
  Map<String, dynamic> toJson() => _$StartConvertMusicRestModelToJson(this);
}
