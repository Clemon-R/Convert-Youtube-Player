import 'package:convertyoutubeplayer/enums/header_domain_enum.dart';
import 'package:convertyoutubeplayer/constant/urls.dart';

import '../base_request_model.dart';
import '../request_model.dart';
import 'check_request_status_request_model.dart';

class StartConvertMusicRequestModel extends BaseRequestModel {
  String url;
  String extension;

  StartConvertMusicRequestModel({this.url, this.extension});

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

  RequestModel<StartConvertMusicRequestModel, CheckRequestStatusRequestModel>
      get request => RequestModel(
          constructor: () => CheckRequestStatusRequestModel(),
          domain: HeaderDomainEnum.Mp3Convert,
          url: Urls.mp3ConvertUrlStart,
          body: this);
}
