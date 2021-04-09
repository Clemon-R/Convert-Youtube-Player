import 'package:convertyoutubeplayer/models/rest_models/irest_model.dart';

class HttpResponseModel<T extends IRestModel> {
  final bool succeed;
  final T? content;
  HttpResponseModel({required this.succeed, this.content});
}
