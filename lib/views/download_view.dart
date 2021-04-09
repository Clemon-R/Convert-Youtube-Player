import 'package:convertyoutubeplayer/provider/services_provider.dart';
import 'package:convertyoutubeplayer/services/player_service.dart';
import 'package:convertyoutubeplayer/components/youtube_download.dart';
import 'package:flutter/material.dart';

class DownloadView extends StatefulWidget {
  DownloadView({Key? key}) : super(key: key);

  @override
  _DownloadViewState createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  PlayerService _playerService = ServicesProvider.get();

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
