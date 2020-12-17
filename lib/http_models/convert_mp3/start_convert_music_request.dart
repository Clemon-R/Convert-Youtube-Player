import 'package:convertyoutubeplayer/utils/reflector.dart';

import '../../urls.dart';
import '../web_request.dart';
import 'check_request_status_request.dart';

//@reflector
class StartConvertMusicRequest {
  final String url;
  final String extension;

  bool success;

  StartConvertMusicRequest({this.url, this.extension});

  StartConvertMusicRequest.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        extension = json['extension'];
  Map<String, dynamic> toJson() => {
        'url': url,
        'extension': extension,
      };

  WebRequest<StartConvertMusicRequest, CheckRequestStatusRequest> get request =>
      WebRequest(
          url: Urls.mp3ConvertUrlStart,
          body: this,
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
