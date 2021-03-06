import 'dart:io';

import 'package:convertyoutubeplayer/enums/header_domain_enum.dart';

class DownloadRequestModel {
  final String fileName;
  final String url;
  final String path;
  final HeaderDomainEnum domain = HeaderDomainEnum.Mp3Convert;
  Function(int downloaded, int sizeMax) onProgress;
  Function(File file) onDone;
  Function() onFail;

  DownloadRequestModel(
      {this.fileName,
      this.path,
      this.url,
      this.onProgress,
      this.onDone,
      this.onFail});
}
