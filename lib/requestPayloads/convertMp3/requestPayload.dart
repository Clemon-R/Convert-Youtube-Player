class RequestPayload<U, T> {
  final String url;
  U body;
  Map<String, String> headers;
  T Function(Map<String, dynamic> json) onSuccess;

  setHeaders(Map<String, String> headerMap) {
    this.headers = headerMap;
  }

  RequestPayload({this.url, this.body, this.onSuccess});
}
