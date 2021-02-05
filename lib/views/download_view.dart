import 'package:convertyoutubeplayer/provider/service_provider.dart';
import 'package:convertyoutubeplayer/services/player_service.dart';
import 'package:convertyoutubeplayer/widgets/youtube_download.dart';
import 'package:flutter/material.dart';

class DownloadView extends StatefulWidget {
  DownloadView({Key key}) : super(key: key);

  @override
  _DownloadViewState createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  PlayerService _playerService = ServiceProvider.get();

  _DownloadViewState();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: YoutubeDownload(onMusicDownloaded: (audio) {
              this._playerService.changeAudio(audio);
            })),
          ],
        ),
      ),
    );
  }
}
