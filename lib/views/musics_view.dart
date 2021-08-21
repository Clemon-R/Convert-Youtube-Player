import 'dart:io';

import 'package:youtekmusic/constant/strings.dart';
import 'package:youtekmusic/models/cache_models/playlist_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/cache_service.dart';
import 'package:youtekmusic/services/player_service.dart';
import 'package:youtekmusic/services/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MusicsView extends StatefulWidget {
  MusicsView({Key? key, this.playlist}) : super(key: key);

  final PlaylistModel? playlist;

  @override
  _MusicsViewState createState() => _MusicsViewState(this.playlist);
}

class _MusicsViewState extends State<MusicsView> {
  final PlaylistService _playlistService = ServicesProvider.get();
  final CacheService _cacheService = ServicesProvider.get();
  final PlayerService _playerService = ServicesProvider.get();

  PlaylistModel? _playlist;

  _MusicsViewState(this._playlist);

  @override
  Widget build(BuildContext context) {
    var defaultPlaylist = this._playlist;
    if (this._playlist == null)
      defaultPlaylist =
          _playlistService.getPlaylistByName(Strings.DEFAULT_PLAYLIST);
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
                          TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(0))),
                            child: Image.network(
                              audio.thumbnailUrl ?? "",
                            ),
                            onPressed: () {
                              this._playerService.changeAudio(audio);
                            },
                          ),
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(EdgeInsets.all(8))),
                              child: SizedBox.expand(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(audio.title ?? "Title",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                    Text(audio.author ?? "Author",
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
                          TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.all(8),
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(16, 16),
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/delete-24px.svg",
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              var file = File(audio.pathFile);

                              if (!await file.exists()) return;
                              await file.delete();

                              _playlistService.removeMusicToPlaylist(
                                  defaultPlaylist!, audio.youtubeUrl);
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
