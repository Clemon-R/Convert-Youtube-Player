import '../../urls.dart';
import './requestPayload.dart';
import 'checkVideoStatusPayloadRequest.dart';

class StartConvertPayloadRequest {
  final String url;
  final String extension;

  StartConvertPayloadRequest(this.url, this.extension);

  StartConvertPayloadRequest.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        extension = json['extension'];
  Map<String, dynamic> toJson() => {
        'url': url,
        'extension': extension,
      };

  RequestPayload<StartConvertPayloadRequest, CheckConvertPayloadRequest>
      get request => RequestPayload(
          url: Urls.mp3ConvertUrlStart,
          body: this,
          onSuccess: (json) {
            return CheckConvertPayloadRequest.fromJson(json);
          });
}
