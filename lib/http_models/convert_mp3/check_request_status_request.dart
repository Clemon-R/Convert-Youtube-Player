import 'package:convertyoutubeplayer/enums/header_domain_enum.dart';
import 'package:convertyoutubeplayer/http_models/default_model.dart';
import 'package:convertyoutubeplayer/urls.dart';

import '../web_request.dart';

class CheckRequestStatusRequest extends DefaultModel {
  String uuid;
  String status;
  int percent;
  String title;
  String thumbnail;
  String fileUrl;
  String url;

  CheckRequestStatusRequest({this.uuid, this.status});

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

  WebRequest<CheckRequestStatusRequest, CheckRequestStatusRequest>
      get request => WebRequest(
          constructor: () => CheckRequestStatusRequest(),
          domain: HeaderDomainEnum.Mp3Convert,
          url: Urls.mp3ConvertUrlCheck.replaceAll(":id", this.uuid));
}
