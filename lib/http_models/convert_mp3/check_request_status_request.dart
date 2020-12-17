import 'package:convertyoutubeplayer/urls.dart';
import 'package:convertyoutubeplayer/utils/reflector.dart';
//import 'package:reflectable/reflectable.dart';

import '../web_request.dart';

//@reflector
class CheckRequestStatusRequest {
  String uuid;
  String status;
  int percent;
  String title;
  String thumbnail;
  String fileUrl;

  bool success;

  CheckRequestStatusRequest({this.uuid, this.status});

  CheckRequestStatusRequest.fromJson(Map<String, dynamic> json)
      : uuid = json['data']['uuid'],
        status = json['data']['status'],
        percent = json['data']['percent'],
        title = json['data']['title'],
        thumbnail = json['data']['thumbnail'],
        fileUrl = json['data']['fileUrl'];
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'status': status,
        'percent': percent,
        'title': title,
        'thumbnail': thumbnail,
        'fileUrl': fileUrl,
      };

  WebRequest<CheckRequestStatusRequest, CheckRequestStatusRequest>
      get request => WebRequest(
          url: Urls.mp3ConvertUrlCheck.replaceAll(":id", this.uuid),
          body: null,
          onSuccess: (json) {
            var result = CheckRequestStatusRequest.fromJson(json);
            result.success = true;
            return result;
          },
          onFail: (json) {
            var result = CheckRequestStatusRequest();
            result.success = false;
            return result;
          });
}
