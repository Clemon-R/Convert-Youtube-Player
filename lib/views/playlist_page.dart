import 'package:convertyoutubeplayer/cache_models/audio_model.dart';
import 'package:convertyoutubeplayer/services/cache_service.dart';
import 'package:convertyoutubeplayer/widgets/audio_mp3_player.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  PlaylistPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  AudioModel _audio;

  Stream<List<AudioModel>> _getAllAudios() async* {
    yield CacheService.instance.content.audios;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(34, 40, 49, 1),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: CacheService.instance.content.audios.length,
                  itemBuilder: (context, index) {
                    var audio = CacheService.instance.content.audios[index];
                    return ListTile(
                      dense: true,
                      tileColor: Color.fromRGBO(48, 71, 94, 1),
                      leading: Image.network(
                        audio.thumbnailUrl,
                      ),
                      title: Text(audio.title,
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        setState(() {
                          this._audio = audio;
                        });
                      },
                    );
                  }),
            ),
            AudioMp3Player(() {
              return this._audio;
            })
          ],
        ));
  }
}
