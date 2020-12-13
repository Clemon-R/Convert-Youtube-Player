import 'package:convertyoutubeplayer/widgets/audio_mp3_player.dart';
import 'package:convertyoutubeplayer/widgets/youtube_download.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DownloadPageState createState() => _DownloadPageState();
}
class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: YoutubeDownload()),
            Container(child: AudioMp3Player())
          ],
        ),
      ),
    );
  }
}