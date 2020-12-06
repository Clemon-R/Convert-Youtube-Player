import 'dart:io';

import 'package:convertyoutubeplayer/enums/HeaderDomainEnum.dart';

class RequestDownload {
  final String fileName;
  final String url;
  final HeaderDomainEnum domain = HeaderDomainEnum.Mp3Convert;
  Map<String, String> headers;
  Function(int downloaded, int sizeMax) onProgress;
  Function(File file) onDone;
  Function() onFail;

  setHeaders(Map<String, String> headerMap) {
    this.headers = headerMap;
  }

  RequestDownload(
      {this.fileName, this.url, this.onProgress, this.onDone, this.onFail});
}
