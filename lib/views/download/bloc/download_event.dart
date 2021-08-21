import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

@immutable
abstract class DownloadEvent {}

class DownloadHiddenBrowserInitiated extends DownloadEvent {
  final WebViewController controller;

  DownloadHiddenBrowserInitiated({required this.controller});
}

class DownloadHiddenBrowserLoaded extends DownloadEvent {}

class DownloadNewYoutubeUrl extends DownloadEvent {
  final String url;

  DownloadNewYoutubeUrl({required this.url});
}

class DownloadStart extends DownloadEvent {}
