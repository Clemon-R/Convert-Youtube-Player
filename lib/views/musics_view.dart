import 'dart:io';

import 'package:convertyoutubeplayer/constant/common.dart';
import 'package:convertyoutubeplayer/models/cache_models/playlist_model.dart';
import 'package:convertyoutubeplayer/provider/service_provider.dart';
import 'package:convertyoutubeplayer/services/player_service.dart';
import 'package:convertyoutubeplayer/services/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MusicsView extends StatefulWidget {
  MusicsView({Key key, this.playlist}) : super(key: key);

  final PlaylistModel playlist;

  @override
  _MusicsViewState createState() => _MusicsViewState(this.playlist);
}

class _MusicsViewState extends State<MusicsView> {
  PlaylistService _playlistService = ServiceProvider.get();
  PlayerService _playerService = ServiceProvider.get();

  PlaylistModel _playlist;

  _MusicsViewState(this._playlist);

  @override
  Widget build(BuildContext context) {
    var defaultPlaylist = this._playlist;
    if (this._playlist == null)
      defaultPlaylist =
          _playlistService.getPlaylistByName(Common.DEFAULT_PLAYLIST);
    var musics = defaultPlaylist?.musics ?? Map();
    return Container(
        color: Color.fromRGBO(34, 40, 49, 1),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: musics.length,
                  itemBuilder: (context, index) {
                    var audio = musics.values.elementAt(index);
                    return Container(
                      color: Color.fromRGBO(48, 71, 94, 1),
                      height: 60,
                      child: Row(
                        children: [
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Image.network(
                              audio.thumbnailUrl,
                            ),
                            onPressed: () {
                              this._playerService.changeAudio(audio);
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
                                    Text(audio?.title ?? "Titre",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                    Text(audio?.author ?? "Autheur",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        )),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                this._playerService.changeAudio(audio);
                              },
                            ),
                          ),
                          FlatButton(
                            padding: const EdgeInsets.all(0),
                            minWidth: 16,
                            child: SvgPicture.asset(
                              "assets/delete-24px.svg",
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              var file = File(audio.pathFile);

                              if (!await file.exists()) return;
                              await file.delete();

                              _playlistService.removeMusicToPlaylist(
                                  defaultPlaylist, audio.youtubeUrl);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
