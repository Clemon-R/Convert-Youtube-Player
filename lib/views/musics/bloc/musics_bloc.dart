import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:youtekmusic/models/cache_models/audio_model.dart';
import 'package:youtekmusic/models/cache_models/playlist_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/player_service.dart';
import 'package:youtekmusic/services/playlist_service.dart';

part 'musics_event.dart';
part 'musics_state.dart';

class MusicsBloc extends Bloc<MusicsEvent, MusicsState> {
  static const TAG = "MusicsBloc";
  final _playlistService = ServicesProvider.get<PlaylistService>();
  final _playerService = ServicesProvider.get<PlayerService>();

  PlaylistModel? _currentPlaylist;

  StreamSubscription<PlaylistModel>? _listenerChangePlaylist;

  MusicsBloc({required String playlistName}) : super(MusicsInitial()) {
    this.add(MusicsChangePlaylist(playlistName: playlistName));
  }
  @override
  Future<void> close() async {
    this._listenerChangePlaylist?.cancel();
    super.close();
  }

  @override
  Stream<MusicsState> mapEventToState(
    MusicsEvent event,
  ) async* {
    try {
      if (event is MusicsChangePlaylist) {
        print("$TAG: Initiating...");
        this._currentPlaylist =
            this._playlistService.getPlaylistByName(event.playlistName);
        this._listenerChangePlaylist?.cancel();
        this._listenerChangePlaylist =
            this._playlistService.onPlaylistChange.listen((playlist) {
          if (playlist.title != event.playlistName) return;
          print("$TAG: Updating current playlist");
          this.add(MusicsChangePlaylist(playlistName: playlist.title));
        });
        if (this._currentPlaylist == null) {
          yield MusicsError();
          return;
        }
        print("$TAG: Initiated");
        yield MusicsInitiated(playlist: this._currentPlaylist!);
      } else if (event is MusicsChangeCurrentMusic) {
        this._playerService.changeAudio(event.audio);
      } else if (event is MusicsDeleteMusic) {
        var file = File(event.audio.pathFile);

        if (!await file.exists()) return;
        await file.delete();

        _playlistService.removeMusicToPlaylist(
            this._currentPlaylist!, event.audio.youtubeUrl);
      }
    } catch (e) {
      print(e);
      yield MusicsError();
    }
  }
}
