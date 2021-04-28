import 'package:youtekmusic/enums/header_domain_enum.dart';
import 'package:youtekmusic/constant/urls.dart';
import 'package:json_annotation/json_annotation.dart';

import '../irest_model.dart';
import '../http_request_model.dart';
import 'check_request_status_rest_model.dart';

part "start_convert_music_request_model.g.dart";

@JsonSerializable(explicitToJson: true)
class StartConvertMusicRestModel extends IRestModel {
  String url;
  String extension;

  StartConvertMusicRestModel({required this.url, required this.extension});

  factory StartConvertMusicRestModel.fromJson(Map<String, dynamic> json) =>
      _$StartConvertMusicRestModelFromJson(json);
  Map<String, dynamic> toJson() => _$StartConvertMusicRestModelToJson(this);

  HttpRequestModel<StartConvertMusicRestModel, CheckRequestStatusRestModel>
      get request => HttpRequestModel(
          fromJson: (json) => CheckRequestStatusRestModel.fromJson(json),
          domain: HeaderDomainEnum.Mp3Convert,
          url: Urls.mp3ConvertUrlStart,
          body: this);
}
