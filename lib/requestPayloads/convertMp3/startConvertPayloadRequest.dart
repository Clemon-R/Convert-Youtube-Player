import '../../urls.dart';
import '../requestPayload.dart';
import 'checkVideoStatusPayloadRequest.dart';

class StartConvertPayloadRequest {
  final String url;
  final String extension;

  bool success;

  StartConvertPayloadRequest({this.url, this.extension});

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
