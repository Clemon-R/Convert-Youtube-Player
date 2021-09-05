import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:youtekmusic/models/cache_models/playlist_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/playlist_service.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  static const TAG = "PlaylistBloc";
  final _playlistService = ServicesProvider.get<PlaylistService>();

  List<PlaylistModel> _playlists = [];
  PlaylistModel? _currentPlaylist;

  PlaylistBloc() : super(PlaylistInitial()) {
    this.add(PlaylistRefresh());
  }

  @override
  Stream<PlaylistState> mapEventToState(
    PlaylistEvent event,
  ) async* {
    try {
      var refresh = true;
      if (event is PlaylistRefresh) {
        this._playlists = this._playlistService.getAllPlaylists();
      } else if (event is PlaylistChangePlaylist) {
        this._currentPlaylist = event.playlist;
      }
      if (refresh)
        yield PlaylistInitiated(
            playlists: this._playlists, currentPlaylist: this._currentPlaylist);
    } catch (e) {
      print(e);
      yield PlaylistError();
    }
  }
}
