import 'package:convertyoutubeplayer/enums/HeaderDomainEnum.dart';

class RequestPayload<U, T> {
  final String url;
  final HeaderDomainEnum domain = HeaderDomainEnum.Mp3Convert;
  U body;
  Map<String, String> headers;
  T Function(Map<String, dynamic> json) onSuccess;
  T Function(Map<String, dynamic> json) onFail;

  setHeaders(Map<String, String> headerMap) {
    this.headers = headerMap;
  }

  RequestPayload({this.url, this.body, this.onSuccess, this.onFail});
}
