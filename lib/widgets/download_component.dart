import 'package:flutter/material.dart';

class DownloadComponent extends StatelessWidget {
  DownloadComponent(
      {required this.onPressDownload,
      required this.disable,
      required this.infoMessage,
      required this.downloadProgress});

  final Function() onPressDownload;

  final bool disable;
  final String infoMessage;
  final double downloadProgress;
  /*final PlaylistService _playlistService = ServicesProvider.get();
  final HttpService _httpService = ServicesProvider.get();
  final TokenService _tokenService = ServicesProvider.get();
  final Function(AudioModel path)? onMusicDownloaded;

  WebViewController? _webViewController;
  Timer? _refreshTimer;

  String _currentUrl = Urls.youtube;*/
/*
  bool _isDownloading = false;
  String? _currentDownload;*/

  /*_YoutubeDownloadState(this.onMusicDownloaded);

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }*/
/*
  _startDownload() async {
    if (!_tokenService.initiated || this._isDownloading) {
      if (!_tokenService.initiated)
        print("$TAG(ERROR): Token service not initiated");
      else
        print("$TAG(ERROR): Is currently downloading");
      return;
    }
    setState(() {
      this._isDownloading = true;
    });
    var downloadRequest =
        StartConvertMusicRestModel(url: this._currentUrl, extension: "mp3");
    var response = await _httpService.post(downloadRequest.request);

    if (response.code != HttpStatus.ok || response.content == null) {
      print("$TAG(ERROR): Start download request failed");

      setState(() {
        this._msg = "Une erreur ses produite";
        this._progress = 1;
        this._isDownloading = false;
      });
      return;
    }
    print(
        "$TAG: Request(${response.content?.uuid}): title ${response.content?.title}, status ${response.content?.status}, percent ${response.content?.percent}");
    setState(() {
      this._currentDownload = this._currentUrl;
      this._msg = response.content!.status;
    });
    _handleAdvancementRequest(response.content!);
  }

  _handleAdvancementRequest(CheckRequestStatusRestModel lastRequest) async {
    if (!this._isDownloading) {
      print("$TAG(ERROR): Is not currently downloading");
      return;
    }
    final response = await _httpService.get(lastRequest.request);
    if (response.code != HttpStatus.ok || response.content == null) {
      print("$TAG(ERROR): Check request failed");
      setState(() {
        this._msg = "Une erreur ses produite";
        this._progress = 1;
        this._isDownloading = false;
      });
      return;
    }
    var checkAgain = false;
    var startDownloadingFile = false;
    setState(() {
      switch (response.content!.status) {
        case "started":
          this._msg = "Demande en cours...";
          this._progress = 0;
          checkAgain = true;
          break;
        case "created":
          this._progress = 0.1;
          checkAgain = true;
          break;
        case "downloading":
          this._msg = "Chargement de la vidéo...";
          this._progress = 0.2;
          checkAgain = true;
          break;
        case "converting":
          this._msg = "Convertion en cours...";
          this._progress = 0.3;
          checkAgain = true;
          break;
        case "converting":
        case "ended":
          this._msg = "Prêt au téléchargement local";
          this._progress = 0.4;
          startDownloadingFile = true;
          break;
      }
    });
    print(
        "$TAG: Request(${response.content?.uuid}): title ${response.content?.title}, status ${response.content?.status}, percent ${response.content?.percent}");
    if (checkAgain)
      _handleAdvancementRequest(response.content!);
    else if (startDownloadingFile) _beginDownloadingFile(response.content!);
  }

  _beginDownloadingFile(CheckRequestStatusRestModel lastRequest) {
    if (!this._isDownloading) return;
    print("$TAG: Downloading the file...");
    var downloadRequest = HttpDownloadRequestModel(
      fileName: "${lastRequest.uuid}.mp3",
      url: lastRequest.fileUrl!,
      path: "musics",
      onProgress: (downloaded, sizeMax) {
        print("$TAG: Download in progress ${downloaded / sizeMax * 100}%");
        setState(() {
          this._msg = "Téléchargement ${(downloaded / sizeMax * 100).round()}%";
          this._progress = downloaded / sizeMax * 0.6 + 0.4;
        });
      },
      onDone: (file) {
        print("$TAG: Download done");
        var audio = AudioModel(
            title: lastRequest.title,
            author: null,
            pathFile: file.path,
            youtubeUrl: this._currentDownload,
            thumbnailUrl: lastRequest.thumbnail);

        var defaultPlaylist =
            _playlistService.getPlaylistByName(Common.DEFAULT_PLAYLIST);
        if (defaultPlaylist == null)
          defaultPlaylist =
              _playlistService.createPlaylist(Common.DEFAULT_PLAYLIST);
        _playlistService.addMusicToPlaylist(defaultPlaylist!, audio);

        this.onMusicDownloaded!(audio);
        setState(() {
          this._msg = "Téléchargé";
          this._progress = 1;
          this._isDownloading = false;
        });
      },
      onFail: () {
        print("$TAG: Download failed");
        setState(() {
          this._msg = "Une erreur ses produite";
          this._progress = 1;
          this._isDownloading = false;
        });
      },
    );
    _httpService.downloadFile(downloadRequest);
  }
*/

  @override
  Widget build(BuildContext context) {
    /*var disabledBtn = this._isDownloading ||
        _playlistService.getMusicFromPlaylist(
                Common.DEFAULT_PLAYLIST, this._currentUrl) !=
            null;*/

    var build = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*this._hiddenBrowser(),
        Expanded(
          child: WebView(
            initialUrl: this._currentUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
          ),
        ),*/
        LinearProgressIndicator(
          value: this.downloadProgress,
          backgroundColor: Colors.grey,
          minHeight: 10,
          valueColor: AlwaysStoppedAnimation(Colors.red),
        ),
      ],
    );
/*
    if (this._msg != null && this._msg!.isNotEmpty)
      build.children
          .add(Text(this._msg!, style: TextStyle(color: Colors.white)));

    build.children.add(ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
        minimumSize: MaterialStateProperty.all(Size(32, 32)),
        backgroundColor: MaterialStateProperty.all(disabledBtn
            ? Color.fromRGBO(240, 84, 84, 0.5)
            : Color.fromRGBO(240, 84, 84, 1)),
      ),
      child: Text("Télécharger",
          style: TextStyle(
              color: disabledBtn
                  ? Color.fromRGBO(221, 221, 221, 1)
                  : Colors.white)),
      onPressed: disabledBtn
          ? null
          : () {
              _startDownload();
            },
    ));*/
    return Container(
      color: Color.fromRGBO(34, 40, 49, 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: this.downloadProgress,
            backgroundColor: Colors.grey,
            minHeight: 10,
            valueColor: AlwaysStoppedAnimation(Colors.red),
          ),
          Text(this.infoMessage, style: TextStyle(color: Colors.white)),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
              minimumSize: MaterialStateProperty.all(Size(32, 32)),
              backgroundColor: MaterialStateProperty.all(this.disable
                  ? Color.fromRGBO(240, 84, 84, 0.5)
                  : Color.fromRGBO(240, 84, 84, 1)),
            ),
            child: Text("Télécharger",
                style: TextStyle(
                    color: this.disable
                        ? Color.fromRGBO(221, 221, 221, 1)
                        : Colors.white)),
            onPressed: !this.disable ? this.onPressDownload : null,
          )
        ],
      ),
    );
  }
/*
  Widget _hiddenBrowser() {
    return Container(
      height: 0,
      width: 0,
      child: WebView(
        initialUrl: Urls.mp3ConvertUrlBrowser,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _tokenService.setController(controller);
        },
        onPageFinished: (url) async {
          print("$TAG: Page loaded, trying to get all token...");

          _tokenService.init();
          var result = await _httpService.get(HttpRequestModel(
              domain: HeaderDomainEnum.Mp3Convert,
              url: Urls.mp3ConvertUrlCsrf));
          _tokenService.init(result.cookie);

          if (this._refreshTimer != null) return;
          this._refreshTimer =
              Timer.periodic(const Duration(milliseconds: 500), (_) async {
            if (this._webViewController == null) return;
            try {
              var url = await this._webViewController!.currentUrl();
              if (url != null && url != this._currentUrl)
                setState(() {
                  this._currentUrl = url;
                });
            } on Exception catch (_) {
              print("$TAG(ERROR): While refresh the current url");
            }
          });
        },
      ),
    );
  }*/
}
