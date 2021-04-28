import 'dart:io';

import 'package:youtekmusic/models/rest_models/irest_model.dart';

class HttpResponseModel<T extends IRestModel> {
  final int code;
  final String? cookie;
  final T? content;
  HttpResponseModel({required this.code, required this.cookie, this.content});
}
