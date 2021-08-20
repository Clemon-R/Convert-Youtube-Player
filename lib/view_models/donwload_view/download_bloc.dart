import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtekmusic/constant/urls.dart';
import 'package:youtekmusic/enums/end_point_enum.dart';
import 'package:youtekmusic/models/rest_models/convert_mp3_rest_models/check_request_status_rest_model.dart';
import 'package:youtekmusic/models/rest_models/convert_mp3_rest_models/start_convert_music_request_model.dart';
import 'package:youtekmusic/models/rest_models/http_request_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/http_service.dart';
import 'package:youtekmusic/services/token_service.dart';

import 'download_event.dart';
import 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  static const TAG = "DownloadBloc";

  final TokenService _tokenService = ServicesProvider.get();
  final HttpService _httpService = ServicesProvider.get();

  bool _isDownloading = false;
  String _infoMessage = "";
  double _downloadProgress = 0;

  String _currentYoutubeUrl = "";

  DownloadBloc() : super(DownloadInitiating());

  @override
  Stream<DownloadState> mapEventToState(event) async* {
    if (event is DownloadHiddenBrowserInitiated) {
      _tokenService.setController(event.controller);
    } else if (event is DownloadHiddenBrowserLoaded) {
      _tokenService.init();
      var result = await _httpService.get(HttpRequestModel(
          domain: EndPointEnum.Mp3Convert, url: Urls.mp3ConvertUrlCsrf));
      _tokenService.init(result.cookie);
      yield this._createInitiatedState();
    } else if (event is DownloadNewYoutubeUrl) {
      this._currentYoutubeUrl = event.url;
    } else if (event is DownloadStart) {
      await this._startDownload();
    }
  }

  _startDownload() async {
    if (!_tokenService.initiated || this._isDownloading) {
      if (!_tokenService.initiated)
        print("$TAG(ERROR): Token service not initiated");
      else
        print("$TAG(ERROR): Is currently downloading");
      return;
    }
    this._isDownloading = true;
    this.emit(this._createInitiatedState());

    var downloadRequest = StartConvertMusicRestModel(
        url: this._currentYoutubeUrl, extension: "mp3");
    var response = await _httpService.post(downloadRequest.request);

    if (response.code != HttpStatus.ok || response.content == null) {
      print("$TAG(ERROR): Start download request failed");

      this._isDownloading = false;
      this._infoMessage = "Une erreur s'est produite";
      this._downloadProgress = 1;
      this.emit(this._createInitiatedState());
      return;
    }
    print(
        "$TAG: Request(${response.content?.uuid}): title ${response.content?.title}, status ${response.content?.status}, percent ${response.content?.percent}");
    this._infoMessage = response.content?.status ?? "";
    /*setState(() {
      this._currentDownload = this._currentYoutubeUrl;
      this._msg = response.content!.status;
    });*/
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
      this._infoMessage = "Une erreur ses produite";
      this._downloadProgress = 1;
      this._isDownloading = false;
      return;
    }
    var checkAgain = false;
    var startDownloadingFile = false;
    switch (response.content?.status ?? "") {
      case "started":
        this._infoMessage = "Demande en cours...";
        this._downloadProgress = 0;
        checkAgain = true;
        break;
      case "created":
        this._downloadProgress = 0.1;
        checkAgain = true;
        break;
      case "downloading":
        this._infoMessage = "Chargement de la vidéo...";
        this._downloadProgress = 0.2;
        checkAgain = true;
        break;
      case "converting":
        this._infoMessage = "Convertion en cours...";
        this._downloadProgress = 0.3;
        checkAgain = true;
        break;
      case "converting":
      case "ended":
        this._infoMessage = "Prêt au téléchargement local";
        this._downloadProgress = 0.4;
        startDownloadingFile = true;
        break;
    }
    this.emit(this._createInitiatedState());
    print(
        "$TAG: Request(${response.content?.uuid}): title ${response.content?.title}, status ${response.content?.status}, percent ${response.content?.percent}");
    if (checkAgain) _handleAdvancementRequest(response.content!);
    //else if (startDownloadingFile) _beginDownloadingFile(response.content!);
  }

  DownloadState _createInitiatedState() {
    return DownloadInitiated(
        isDownloading: this._isDownloading,
        downloadProgress: this._downloadProgress,
        infoMessage: this._infoMessage);
  }
}
