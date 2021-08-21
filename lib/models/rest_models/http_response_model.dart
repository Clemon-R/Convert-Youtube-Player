import 'package:youtekmusic/models/rest_models/irest_model.dart';

class HttpResponseModel<T extends IRestModel> {
  final int code;
  final String? cookies;
  final T? content;
  HttpResponseModel({required this.code, required this.cookies, this.content});
}
