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

  PlaylistBloc() : super(PlaylistInitial()) {
    this.add(PlaylistRefresh());
  }

  @override
  Stream<PlaylistState> mapEventToState(
    PlaylistEvent event,
  ) async* {
    try {
      if (event is PlaylistRefresh) {
        this._playlists = this._playlistService.getAllPlaylists();
        yield PlaylistInitiated(
            playlists: this._playlists, currentPlaylist: null);
      }
    } catch (e) {
      print(e);
      yield PlaylistError();
    }
  }
}
