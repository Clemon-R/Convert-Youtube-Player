import 'package:youtekmusic/enums/header_domain_enum.dart';

import 'irest_model.dart';

class HttpRequestModel<U extends IRestModel, T extends IRestModel> {
  final String url;
  final HeaderDomainEnum domain;
  U? body;
  T Function(Map<String, dynamic> json)? fromJson;

  HttpRequestModel(
      {this.fromJson, required this.domain, required this.url, this.body});
}
