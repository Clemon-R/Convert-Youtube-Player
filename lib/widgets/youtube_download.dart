import 'dart:async';
import 'dart:io';

import 'package:convertyoutubeplayer/Services/http_service.dart';
import 'package:convertyoutubeplayer/Services/token_service.dart';
import 'package:convertyoutubeplayer/cache_models/audio_model.dart';
import 'package:convertyoutubeplayer/http_models/convert_mp3/check_request_status_request.dart';
import 'package:convertyoutubeplayer/http_models/convert_mp3/start_convert_music_request.dart';
import 'package:convertyoutubeplayer/http_models/file_download_request.dart';
import 'package:convertyoutubeplayer/services/cache_service.dart';
import 'package:convertyoutubeplayer/urls.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeDownload extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this case nothing) provided by the parent and used
  // by the build  method of the State. Fields in a Widget
  // subclass are always marked "final".

  YoutubeDownload({Key key, this.onMusicDownloaded}) : super(key: key);

  final Function(AudioModel path) onMusicDownloaded;

  @override
  _YoutubeDownloadState createState() =>
      _YoutubeDownloadState(this.onMusicDownloaded);
}

class _YoutubeDownloadState extends State<YoutubeDownload> {
  final Function(AudioModel path) onMusicDownloaded;

  CheckRequestStatusRequest _lastResult;
  FileDownloadRequest _lastDownload;
  WebViewController _webViewController;
  Timer _refreshTimer;

  String _currentUrl = Urls.youtube;
  String _downloadYoutubeUrl;
  //var _currentFile = "";
  var _msg = "";
  var _progress = 0.0;

  _YoutubeDownloadState(this.onMusicDownloaded);

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void _startDownload() {
    if (!TokenService.instance.initiated || this._lastResult != null) return;
    setState(() {
      //this._currentFile = null;
      this._lastDownload = null;
    });
    var tmp = StartConvertMusicRequest(url: this._currentUrl, extension: "mp3");
    HttpService.instance.post(tmp.request).then((result) {
      if (!result.success) {
        print("(ERROR): Request failed");
        this._msg = "Une erreur ses produite";
        this._progress = 1;
        return;
      }
      print(
          "Request(${result.uuid}): title ${result.title}, status ${result.status}, percent ${result.percent}");
      setState(() {
        this._downloadYoutubeUrl = this._currentUrl;
        this._lastResult = result;
        this._msg = result.status;
      });
    });
  }

  void _checkIfNeeded() {
    if (this._lastResult != null &&
        (this._lastResult.status == "created" ||
            this._lastResult.status == "started" ||
            this._lastResult.status == "downloading" ||
            this._lastResult.status == "converting")) {
      print("Request not done");
      HttpService.instance.get(this._lastResult.request).then((result) {
        if (!result.success) {
          print("(ERROR): Request failed");
          this._lastResult = null;
          this._msg = "Une erreur ses produite";
          this._progress = 1;
          return;
        }
        setState(() {
          this._lastResult = result;
          switch (this._lastResult.status) {
            case "started":
              this._msg = "Demande en cours...";
              this._progress = 0;
              break;
            case "created":
              this._progress = 0.1;
              break;
            case "downloading":
              this._msg = "Chargement de la vidéo...";
              this._progress = 0.2;
              break;
            case "converting":
              this._msg = "Convertion en cours...";
              this._progress = 0.3;
              break;
            case "ended":
              this._msg = "Prêt au téléchargement local";
              this._progress = 0.4;
              break;
          }
        });
        print(
            "Request(${result.uuid}): title ${result.title}, status ${result.status}, percent ${result.percent}");
      });
    }
  }

  void _checkIfCanDownloadFile() {
    if (this._lastDownload != null ||
        this._lastResult == null ||
        this._lastResult.status != "ended") return;
    print("Request done\nDownloading...");
    _lastDownload = FileDownloadRequest(
      fileName: "${this._lastResult.uuid}.mp3",
      url: this._lastResult.fileUrl,
      onProgress: (downloaded, sizeMax) {
        print("Download in progress ${downloaded / sizeMax * 100}%");
        setState(() {
          this._msg = "Téléchargement...";
          this._progress = downloaded / sizeMax * 0.6 + 0.4;
        });
      },
      onDone: (file) {
        //_currentFile = file.path;
        var audio = AudioModel(
            title: this._lastResult.title,
            author: null,
            pathFile: file.path,
            youtubeUrl: this._downloadYoutubeUrl,
            thumbnailUrl: this._lastResult.thumbnail);

        if (!CacheService.instance.content.audios
            .any((element) => element.youtubeUrl == audio.youtubeUrl)) {
          CacheService.instance.content.audios.add(audio);
          CacheService.instance.saveCache();
        }

        this.onMusicDownloaded(audio);
        setState(() {
          this._lastResult = null;
          this._lastDownload = null;
          this._msg = "Téléchargé";
          this._progress = 1;
        });
      },
      onFail: () {
        setState(() {
          this._lastResult = null;
          this._lastDownload = null;
          this._msg = "Une erreur ses produite";
          this._progress = 1;
        });
      },
    );
    HttpService.instance.downloadFile(this._lastDownload);
  }

  @override
  Widget build(BuildContext context) {
    _checkIfNeeded();
    _checkIfCanDownloadFile();
    var build = Column(
      children: [
        Container(
          height: 0,
          width: 0,
          child: WebView(
            initialUrl: Urls.mp3ConvertUrlBrowser,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              TokenService.instance.setController(controller);
            },
            onPageFinished: (url) {
              TokenService.instance.init();

              const halfSecond = const Duration(milliseconds: 500);
              if (this._refreshTimer != null) return;
              this._refreshTimer =
                  new Timer.periodic(halfSecond, (Timer t) async {
                if (this._webViewController == null) return;
                var url = await this._webViewController.currentUrl();
                if (url != this._currentUrl)
                  setState(() {
                    this._currentUrl = url;
                  });
              });
            },
          ),
        ),
        Expanded(
          child: WebView(
            initialUrl: this._currentUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
          ),
        ),
        LinearProgressIndicator(
          value: this._progress,
          backgroundColor: Colors.grey,
          minHeight: 10,
          valueColor: AlwaysStoppedAnimation(Colors.red),
        ),
      ],
    );
    if (this._msg.isNotEmpty)
      build.children
          .add(Text(this._msg, style: TextStyle(color: Colors.white)));

    build.children.add(FlatButton(
      color: Color.fromRGBO(240, 84, 84, 1),
      textColor: Colors.white,
      disabledTextColor: Color.fromRGBO(221, 221, 221, 1),
      disabledColor: Color.fromRGBO(240, 84, 84, 0.5),
      child: Text("Télécharger"),
      onPressed: this._lastResult != null ||
              this._lastDownload != null ||
              CacheService.instance.content.audios
                  .any((audio) => audio.youtubeUrl == this._currentUrl)
          ? null
          : () async {
              _startDownload();
            },
    ));
    return Container(
      color: Color.fromRGBO(34, 40, 49, 1.0),
      child: build,
    );
  }
}
