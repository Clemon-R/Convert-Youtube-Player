import 'package:flutter/widgets.dart';

@immutable
abstract class DownloadState {}

class DownloadInitiating extends DownloadState {}

class DownloadInitiated extends DownloadState {
  final bool isDownloading;
  final String infoMessage;
  final double downloadProgress;

  DownloadInitiated({
    required this.isDownloading,
    required this.infoMessage,
    required this.downloadProgress,
  });
}
