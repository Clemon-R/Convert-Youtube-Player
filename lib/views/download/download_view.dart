import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtekmusic/enums/end_point_enum.dart';
import 'package:youtekmusic/enums/urls_enum.dart';
import 'package:youtekmusic/provider/blocs_provider.dart';
import 'package:youtekmusic/views/download/bloc/download_bloc.dart';
import 'package:youtekmusic/views/download/bloc/download_event.dart';
import 'package:youtekmusic/views/download/bloc/download_state.dart';
import 'package:youtekmusic/widgets/download_widget.dart';

class DownloadView extends StatelessWidget {
  static const TAG = "DownloadView";

  late final DownloadBloc _bloc;

  late final WebViewController _webViewController;
  Timer? _urlMonitoringTimer;
  String? _currentYoutubeUrl;

  DownloadView() {
    if (BlocsProvider.isSaved<DownloadBloc>()) {
      this._bloc = BlocsProvider.get();
    } else {
      this._bloc = DownloadBloc();
      BlocsProvider.set(this._bloc);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocBuilder<DownloadBloc, DownloadState>(
        builder: (context, state) {
          if (state is DownloadInitiating) {
            print("$TAG: Displaying hidden browser");
            return Column(
              children: [
                this._buildHiddenBrowser(),
                this._buildLoadingScreen(),
              ],
            );
          } else if (state is DownloadInitiated) {
            print("$TAG: Displaying download view");

            return Column(
              children: [
                this._buildView(context),
                DownloadComponent(
                  onPressDownload: () {
                    print("$TAG: Start download");
                    this._bloc.add(DownloadStart());
                  },
                  disable: state.isDownloading,
                  downloadProgress: state.downloadProgress,
                  infoMessage: state.infoMessage,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildView(BuildContext context) {
    return Expanded(
      child: WebView(
        initialUrl: "https://www.youtube.com/",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          this._webViewController = controller;
        },
        onPageFinished: (_) {
          if (this._urlMonitoringTimer != null) return;
          print("$TAG: Url monitor starting...");
          this._urlMonitoringTimer =
              Timer.periodic(const Duration(milliseconds: 500), (_) async {
            try {
              var url = await this._webViewController.currentUrl();
              if (url != null && url != this._currentYoutubeUrl) {
                print("$TAG: New youtube url $url");
                this._bloc.add(DownloadNewYoutubeUrl(url: url));
                this._currentYoutubeUrl = url;
              }
            } on Exception catch (_) {
              print("$TAG(ERROR): While refresh the current url");
            }
          });
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Chargement..."),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiddenBrowser() {
    return Container(
      height: 1,
      width: 1,
      child: WebView(
        initialUrl: UrlsEnum.browser.toUrlString(EndPointEnum.Mp3Convert),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          print("$TAG: Hidden Webview created");
          _bloc.add(DownloadHiddenBrowserInitiated(controller: controller));
        },
        onPageFinished: (url) async {
          print("$TAG: Page loaded, trying to get all token...");
          _bloc.add(DownloadHiddenBrowserLoaded());
        },
      ),
    );
  }
}
