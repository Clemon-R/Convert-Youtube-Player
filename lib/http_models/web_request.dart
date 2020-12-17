import 'dart:convert';

import 'package:convertyoutubeplayer/enums/HeaderDomainEnum.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'default_model.dart';

class WebRequest<U, T extends DefaultModel> {
  final String url;
  final HeaderDomainEnum domain;
  U body;
  T Function(String data, bool success) onDone;
  T Function() constructor;

  WebRequest(
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
