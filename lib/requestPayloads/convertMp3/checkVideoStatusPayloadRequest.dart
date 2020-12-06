import 'package:convertyoutubeplayer/urls.dart';

import '../requestPayload.dart';

class CheckConvertPayloadRequest {
  String uuid;
  String status;
  int percent;
  String title;
  String thumbnail;
  String fileUrl;

  bool success;

  CheckConvertPayloadRequest({this.uuid, this.status});

  CheckConvertPayloadRequest.fromJson(Map<String, dynamic> json)
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

  RequestPayload<CheckConvertPayloadRequest, CheckConvertPayloadRequest>
      get request => RequestPayload(
          url: Urls.mp3ConvertUrlCheck.replaceAll(":id", this.uuid),
          body: null,
          onSuccess: (json) {
            var result = CheckConvertPayloadRequest.fromJson(json);
            result.success = true;
            return result;
          },
          onFail: (json) {
            var result = CheckConvertPayloadRequest();
            result.success = false;
            return result;
          });
}
