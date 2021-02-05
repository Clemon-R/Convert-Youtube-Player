import 'dart:io';

import 'package:convertyoutubeplayer/constant/common.dart';
import 'package:convertyoutubeplayer/models/cache_models/playlist_model.dart';
import 'package:convertyoutubeplayer/provider/service_provider.dart';
import 'package:convertyoutubeplayer/services/playlist_service.dart';
import 'package:convertyoutubeplayer/widgets/audio_mp3_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MusicsView extends StatefulWidget {
  MusicsView({@required this.audioMp3Player, Key key}) : super(key: key);

  final AudioMp3Player audioMp3Player;

  @override
  _MusicsViewState createState() => _MusicsViewState(this.audioMp3Player);
}

class _MusicsViewState extends State<MusicsView> {
  static const String TAG = "MusicView";

  PlaylistService _playlistService = ServiceProvider.get();
  AudioMp3Player _audioMp3Player;

  _MusicsViewState(this._audioMp3Player);

  @override
  void initState() {
    print("$TAG: Test");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlaylistModel defaultPlaylist =
        _playlistService.getPlaylistByName(Common.DEFAULT_PLAYLIST) ??
            List.empty();
    return Container(
        color: Color.fromRGBO(34, 40, 49, 1),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: defaultPlaylist.musics.length,
                  itemBuilder: (context, index) {
                    var audio = defaultPlaylist.musics[index];
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
                              this._audioMp3Player.loadAudio(audio);
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
                                this._audioMp3Player.loadAudio(audio);
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
