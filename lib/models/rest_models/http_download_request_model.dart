import 'dart:io';

import 'package:youtekmusic/enums/header_domain_enum.dart';

class HttpDownloadRequestModel {
  final String fileName;
  final String url;
  final String path;
  final HeaderDomainEnum domain = HeaderDomainEnum.Mp3Convert;
  Function(int downloaded, int sizeMax)? onProgress;
  Function(File file)? onDone;
  Function()? onFail;

  HttpDownloadRequestModel(
      {required this.fileName,
      required this.path,
      required this.url,
      this.onProgress,
      this.onDone,
      this.onFail});
}
