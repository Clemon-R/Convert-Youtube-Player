import 'package:convertyoutubeplayer/enums/header_domain_enum.dart';
import 'package:convertyoutubeplayer/models/http_models/base_request_model.dart';
import 'package:convertyoutubeplayer/constant/urls.dart';

import '../request_model.dart';

class CheckRequestStatusRequestModel extends BaseRequestModel {
  String uuid;
  String status;
  int percent;
  String title;
  String thumbnail;
  String fileUrl;
  String url;

  CheckRequestStatusRequestModel({this.uuid, this.status});

  @override
  fromJson(Map<String, dynamic> json) {
    this.uuid = json['data']['uuid'];
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
      };

  RequestModel<CheckRequestStatusRequestModel, CheckRequestStatusRequestModel>
      get request => RequestModel(
          constructor: () => CheckRequestStatusRequestModel(),
          domain: HeaderDomainEnum.Mp3Convert,
          url: Urls.mp3ConvertUrlCheck.replaceAll(":id", this.uuid));
}
