import 'package:convertyoutubeplayer/enums/HeaderDomainEnum.dart';

import '../../urls.dart';
import '../default_model.dart';
import '../web_request.dart';
import 'check_request_status_request.dart';

class StartConvertMusicRequest extends DefaultModel {
  String url;
  String extension;

  StartConvertMusicRequest({this.url, this.extension});

  @override
  fromJson(Map<String, dynamic> json) {
    this.url = json['url'];
    this.extension = json['extension'];
  }

  @override
  Map<String, dynamic> toJson() => {
        'url': url,
        'extension': extension,
      };

  WebRequest<StartConvertMusicRequest, CheckRequestStatusRequest> get request =>
      WebRequest(
          constructor: () => CheckRequestStatusRequest(),
          domain: HeaderDomainEnum.Mp3Convert,
          url: Urls.mp3ConvertUrlStart,
          body: this);
}
