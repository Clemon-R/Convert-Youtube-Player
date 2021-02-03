import 'package:convertyoutubeplayer/widgets/audio_mp3_player.dart';
import 'package:convertyoutubeplayer/widgets/youtube_download.dart';
import 'package:flutter/material.dart';

class DownloadView extends StatefulWidget {
  DownloadView({Key key, this.title, @required this.audioMp3Player})
      : super(key: key);

  final String title;
  final AudioMp3Player audioMp3Player;

  @override
  _DownloadViewState createState() => _DownloadViewState(this.audioMp3Player);
}

class _DownloadViewState extends State<DownloadView> {
  AudioMp3Player audioMp3Player;

  _DownloadViewState(this.audioMp3Player);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: YoutubeDownload(onMusicDownloaded: (audio) {
              this.audioMp3Player.loadAudio(audio);
            })),
          ],
        ),
      ),
    );
  }
}
