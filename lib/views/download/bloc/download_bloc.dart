import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtekmusic/models/rest_models/convert_mp3_rest_models/check_request_status_rest_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/repositories/mp3_converter_repository.dart';
import 'package:youtekmusic/services/token_service.dart';

import 'download_event.dart';
import 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  static const TAG = "DownloadBloc";

  final _tokenService = ServicesProvider.get<TokenService>();
  final _mp3ConverterRepository =
      ServicesProvider.get<Mp3ConverterRepository>();

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
      await _tokenService.init();
      var result = await _mp3ConverterRepository.getCookiesFromCsrf();
      await _tokenService.init(result);
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
    this.emit(this._createInitiatedState()); //TODO: changer emit par un event
    try {
      var convertionRequest =
          await _mp3ConverterRepository.startYoutubeConvertion(
              url: this._currentYoutubeUrl, extension: "mp3");
      print(
          "$TAG: Request(${convertionRequest.uuid}): title ${convertionRequest.title}, status ${convertionRequest.status}, percent ${convertionRequest.percent}");
      this._infoMessage = convertionRequest.status;
      _handleAdvancementRequest(convertionRequest);
    } catch (_) {
      print("$TAG(ERROR): Start download request failed");

      this._isDownloading = false;
      this._infoMessage = "Une erreur s'est produite";
      this._downloadProgress = 1;
      this.emit(this._createInitiatedState()); //TODO: changer emit par un event
      return;
    }
  }

  _handleAdvancementRequest(CheckRequestStatusRestModel lastRequest) async {
    if (!this._isDownloading) {
      print("$TAG(ERROR): Is not currently downloading");
      return;
    }
    try {
      var convertionRequest = await _mp3ConverterRepository
          .checkYoutubeConvertion(requestId: lastRequest.uuid);

      var checkAgain = false;
      var startDownloadingFile = false;
      switch (convertionRequest.status) {
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
          "$TAG: Request(${convertionRequest.uuid}): title ${convertionRequest.title}, status ${convertionRequest.status}, percent ${convertionRequest.percent}");
      if (checkAgain) _handleAdvancementRequest(convertionRequest);
      //else if (startDownloadingFile) _beginDownloadingFile(convertionRequest);
    } catch (_) {
      print("$TAG(ERROR): Check request failed");
      this._infoMessage = "Une erreur ses produite";
      this._downloadProgress = 1;
      this._isDownloading = false;
      return;
    }
  }

  DownloadState _createInitiatedState() {
    return DownloadInitiated(
        isDownloading: this._isDownloading,
        downloadProgress: this._downloadProgress,
        infoMessage: this._infoMessage);
  }
}
