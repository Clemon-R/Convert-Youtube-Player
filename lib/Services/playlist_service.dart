import 'package:convertyoutubeplayer/models/cache_models/audio_model.dart';
import 'package:convertyoutubeplayer/models/cache_models/playlist_model.dart';
import 'package:convertyoutubeplayer/provider/service_provider.dart';
import 'package:convertyoutubeplayer/services/base_service.dart';
import 'package:convertyoutubeplayer/services/cache_service.dart';

class PlaylistService extends BaseService {
  CacheService _cacheService = ServiceProvider.get();

  PlaylistService(this._cacheService);

  /// You just to give a [playlistName], [youtubeUrl] and then the audio will be returned
  /// Return a `AudioModel` on if it exists
  AudioModel getMusicFromPlaylist(String playlistName, String youtubeUrl) {
    if (!_cacheService.content.playlists.containsKey(playlistName)) return null;

    var data = _cacheService.content.playlists[playlistName];
    if (!data.musics.containsKey(youtubeUrl)) return null;

    return data.musics[youtubeUrl];
  }

  List<PlaylistModel> getAllPlaylists() {
    return _cacheService.content.playlists.values.toList(growable: false);
  }

  /// You just to give a [playlistName], [audio]
  /// Return a `bool` on if eitheir it was successfull or not
  bool addMusicToPlaylistByName(String playlistName, AudioModel audio) {
    if (!_cacheService.content.playlists.containsKey(playlistName) ||
        audio == null) return false;

    var data = _cacheService.content.playlists[playlistName];
    data.musics[audio.youtubeUrl] = audio;
    audio.playlist = data;
    _cacheService.saveCache();
    return true;
  }

  /// You just to give a [playlist], [audio] and then the playlist will be returned
  PlaylistModel addMusicToPlaylist(PlaylistModel playlist, AudioModel audio) {
    playlist.musics[audio.youtubeUrl] = audio;
    audio.playlist = playlist;
    _cacheService.saveCache();
    return playlist;
  }

  /// You just to give a [playlist], [youtubeUrl] and then the playlist will be returned
  PlaylistModel removeMusicToPlaylist(
      PlaylistModel playlist, String youtubeUrl) {
    playlist.musics.remove(youtubeUrl);
    _cacheService.saveCache();
    return playlist;
  }

  /// You just to give a [playlistName] and then the playlist will be returned
  /// Return a `PlaylistModel` or null if the playlist doesn't exists
  PlaylistModel getPlaylistByName(String playlistName) {
    if (!_cacheService.content.playlists.containsKey(playlistName)) return null;

    var data = _cacheService.content.playlists[playlistName];

    return data;
  }

  /// You just to give a [playlistName] and then the playlist will be created if it is not available
  /// Return a `PlaylistModel` or null if the playlist already exists
  PlaylistModel createPlaylist(String playlistName) {
    if (_cacheService.content.playlists.containsKey(playlistName)) return null;

    var data = PlaylistModel(title: playlistName, musics: Map());

    _cacheService.content.playlists[playlistName] = data;
    _cacheService.saveCache();

    return data;
  }
}
