import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/player_service.dart';
import 'package:youtekmusic/components/youtube_download.dart';
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
