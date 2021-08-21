import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtekmusic/constant/strings.dart';
import 'package:youtekmusic/models/cache_models/audio_model.dart';
import 'package:youtekmusic/models/rest_models/convert_mp3_rest_models/check_request_status_rest_model.dart';
import 'package:youtekmusic/models/rest_models/http_download_request_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/repositories/mp3_converter_repository.dart';
import 'package:youtekmusic/services/http_service.dart';
import 'package:youtekmusic/services/playlist_service.dart';
import 'package:youtekmusic/services/token_service.dart';

import 'download_event.dart';
import 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  static const TAG = "DownloadBloc";

  final _tokenService = ServicesProvider.get<TokenService>();
  final _httpService = ServicesProvider.get<HttpService>();
  final _playlistService = ServicesProvider.get<PlaylistService>();
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
    } else if (event is DownloadRefresh) {
      yield this._createInitiatedState();
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
    this.add(DownloadRefresh());
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
      this.add(DownloadRefresh());
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
      this.add(DownloadRefresh());
      print(
          "$TAG: Request(${convertionRequest.uuid}): title ${convertionRequest.title}, status ${convertionRequest.status}, percent ${convertionRequest.percent}");
      if (checkAgain)
        _handleAdvancementRequest(convertionRequest);
      else if (startDownloadingFile) _beginDownloadingFile(convertionRequest);
    } catch (_) {
      print("$TAG(ERROR): Check request failed");
      this._infoMessage = "Une erreur ses produite";
      this._downloadProgress = 1;
      this._isDownloading = false;
      return;
    }
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
        this._infoMessage =
            "Téléchargement ${(downloaded / sizeMax * 100).round()}%";
        this._downloadProgress = downloaded / sizeMax * 0.6 + 0.4;
        this.add(DownloadRefresh());
      },
      onDone: (file) {
        print("$TAG: Download done");
        var audio = AudioModel(
            title: lastRequest.title,
            author: null,
            pathFile: file.path,
            youtubeUrl: this._currentYoutubeUrl,
            thumbnailUrl: lastRequest.thumbnail);

        var defaultPlaylist =
            _playlistService.getPlaylistByName(Strings.DEFAULT_PLAYLIST);
        if (defaultPlaylist == null)
          defaultPlaylist =
              _playlistService.createPlaylist(Strings.DEFAULT_PLAYLIST);
        _playlistService.addMusicToPlaylist(defaultPlaylist!, audio);

        this._infoMessage = "Téléchargé";
        this._downloadProgress = 1;
        this._isDownloading = false;
        this.add(DownloadRefresh());
      },
      onFail: () {
        print("$TAG: Download failed");
        this._infoMessage = "Une erreur ses produite";
        this._downloadProgress = 1;
        this._isDownloading = false;
        this.add(DownloadRefresh());
      },
    );
    _httpService.downloadFile(downloadRequest);
  }

  DownloadState _createInitiatedState() {
    return DownloadInitiated(
        isDownloading: this._isDownloading,
        downloadProgress: this._downloadProgress,
        infoMessage: this._infoMessage);
  }
}
