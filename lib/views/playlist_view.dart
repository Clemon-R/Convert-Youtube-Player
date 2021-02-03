import 'package:convertyoutubeplayer/widgets/audio_mp3_player.dart';
import 'package:flutter/material.dart';

class PlaylistView extends StatefulWidget {
  PlaylistView({Key key, this.title, @required this.audioMp3Player})
      : super(key: key);

  final String title;
  final AudioMp3Player audioMp3Player;

  @override
  _PlaylistViewState createState() => _PlaylistViewState(this.audioMp3Player);
}

class _PlaylistViewState extends State<PlaylistView> {
  AudioMp3Player _audioMp3Player;
  _PlaylistViewState(this._audioMp3Player);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(34, 40, 49, 1),
    );
  }
}
