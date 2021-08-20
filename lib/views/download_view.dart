import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtekmusic/constant/urls.dart';
import 'package:youtekmusic/provider/view_models_provider.dart';
import 'package:youtekmusic/view_models/donwload_view/download_bloc.dart';
import 'package:youtekmusic/view_models/donwload_view/download_event.dart';
import 'package:youtekmusic/view_models/donwload_view/download_state.dart';
import 'package:youtekmusic/widgets/download_component.dart';

class DownloadView extends StatelessWidget {
  static const TAG = "DownloadView";

  late final DownloadBloc _viewModel;

  WebViewController? _webViewController;
  Timer? _urlMonitoringTimer;
  String? _currentYoutubeUrl;

  DownloadView() {
    if (ViewModelsProvider.isSaved<DownloadBloc>()) {
      this._viewModel = ViewModelsProvider.get();
    } else {
      this._viewModel = DownloadBloc();
      ViewModelsProvider.set(this._viewModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return BlocProvider(
      create: (context) => _viewModel,
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
                    this._viewModel.add(DownloadStart());
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
    /*return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: YoutubeDownload(onMusicDownloaded: (audio) {
                this._playerService.changeAudio(audio);
              }),
            ),
          ],
        ),
      ),
    );*/
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
              var url = await this._webViewController?.currentUrl();
              if (url != null && url != this._currentYoutubeUrl) {
                print("$TAG: New youtube url $url");
                this._viewModel.add(DownloadNewYoutubeUrl(url: url));
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
        initialUrl: Urls.mp3ConvertUrlBrowser,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          print("$TAG: Hidden Webview created");
          this._webViewController = controller;
          _viewModel
              .add(DownloadHiddenBrowserInitiated(controller: controller));
        },
        onPageFinished: (url) async {
          print("$TAG: Page loaded, trying to get all token...");
          _viewModel.add(DownloadHiddenBrowserLoaded());
        },
      ),
    );
  }
}
