import 'package:convertyoutubeplayer/enums/header_domain_enum.dart';
import 'package:convertyoutubeplayer/models/rest_models/irest_model.dart';
import 'package:convertyoutubeplayer/constant/urls.dart';
import 'package:json_annotation/json_annotation.dart';

import '../http_request_model.dart';

part 'check_request_status_rest_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckRequestStatusRestModel extends IRestModel {
  String uuid;
  String status;
  int? percent;
  String? title;
  String? thumbnail;
  String? fileUrl;
  String? url;

  CheckRequestStatusRestModel(
      {required this.uuid,
      required this.status,
      required this.percent,
      required this.title,
      required this.thumbnail,
      required this.fileUrl,
      required this.url});

  factory CheckRequestStatusRestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckRequestStatusRestModelFromJson(json["data"]);
  Map<String, dynamic> toJson() => _$CheckRequestStatusRestModelToJson(this);

  /*factory CheckRequestStatusRestModel.fromJson(Map<String, dynamic>? json) {
    this.uuid = json!['data']['uuid'];
    this.status = json['data']['status'];
    this.percent = json['data']['percent'];
    this.title = json['data']['title'];
    this.thumbnail = json['data']['thumbnail'];
    this.fileUrl = json['data']['fileUrl'];
    this.url = json['data']['url'];
  }

  @override
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'status': status,
        'percent': percent,
        'title': title,
        'thumbnail': thumbnail,
        'fileUrl': fileUrl,
        'url': url,
      };*/

  HttpRequestModel<CheckRequestStatusRestModel, CheckRequestStatusRestModel>
      get request => HttpRequestModel(
          fromJson: (json) => CheckRequestStatusRestModel.fromJson(json),
          domain: HeaderDomainEnum.Mp3Convert,
          url: Urls.mp3ConvertUrlCheck.replaceAll(":id", this.uuid));
}
