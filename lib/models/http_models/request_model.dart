import 'dart:convert';

import 'package:convertyoutubeplayer/enums/header_domain_enum.dart';
import 'package:flutter/widgets.dart';

import 'base_request_model.dart';

class RequestModel<U, T extends BaseRequestModel> {
  final String url;
  final HeaderDomainEnum domain;
  U body;
  T Function(String data, bool success) onDone;
  T Function() constructor;

  RequestModel(
      {@required this.constructor,
      @required this.domain,
      @required this.url,
      this.body}) {
    this.onDone = (data, success) {
      T result;
      try {
        result = this.constructor();
        result.fromJson(jsonDecode(data));
        result.success = success;
      } on Exception catch (ex) {
        result = null;
        print(ex.toString());
      }
      return result;
    };
  }
}
