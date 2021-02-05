import 'package:convertyoutubeplayer/models/cache_models/playlist_model.dart';
import 'package:convertyoutubeplayer/provider/service_provider.dart';
import 'package:convertyoutubeplayer/services/player_service.dart';
import 'package:convertyoutubeplayer/services/playlist_service.dart';
import 'package:convertyoutubeplayer/views/musics_view.dart';
import 'package:convertyoutubeplayer/widgets/audio_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlaylistView extends StatefulWidget {
  PlaylistView({Key key}) : super(key: key);

  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  PlaylistService _playlistService = ServiceProvider.get();
  PlayerService _playerService = ServiceProvider.get();

  PlaylistModel _currentPlaylist = null;

  _PlaylistViewState();

  void _goToPlaylistList() {
    setState(() {
      this._currentPlaylist = null;
    });
  }

  void _goToPlaylist(PlaylistModel playlist) {
    setState(() {
      this._currentPlaylist = playlist;
    });
  }

  Widget _playlistListView() {
    var playlists = _playlistService
        .getAllPlaylists()
        .where((playlist) => playlist.musics.length > 0)
        .toList();
    return Container(
        color: Color.fromRGBO(34, 40, 49, 1),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    var playlist = playlists[index];
                    var firstAudio = playlist.musics.values.first;
                    return Container(
                      color: Color.fromRGBO(48, 71, 94, 1),
                      height: 60,
                      child: Row(
                        children: [
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Image.network(
                              firstAudio.thumbnailUrl,
                            ),
                            onPressed: () {
                              this._goToPlaylist(playlist);
                            },
                          ),
                          Expanded(
                            child: FlatButton(
                              padding: EdgeInsets.all(8),
                              child: SizedBox.expand(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(playlist?.title ?? "Titre",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                    Text("${playlist.musics.length} Musiques",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        )),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                this._goToPlaylist(playlist);
                              },
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            minWidth: 16,
                            child: SvgPicture.asset(
                              "assets/delete-24px.svg",
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ));
  }

  Widget _currentPlaylistView() {
    return Container(
      color: Color.fromRGBO(34, 40, 49, 1),
      child: Column(
        children: [
          Container(
            height: 32,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(48, 71, 94, 1),
              border: Border(
                bottom: BorderSide(
                    width: 1.0, color: Color.fromRGBO(34, 40, 49, 1)),
              ),
            ),
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                this._goToPlaylistList();
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: SvgPicture.asset(
                      "assets/arrow_back_ios_new-24px.svg",
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(this._currentPlaylist?.title ?? "Playlist",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: MusicsView(playlist: this._currentPlaylist)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AudioHeader(),
          Expanded(
            child: Container(
              child: IndexedStack(
                index: this._currentPlaylist == null ? 0 : 1,
                children: [_playlistListView(), _currentPlaylistView()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
