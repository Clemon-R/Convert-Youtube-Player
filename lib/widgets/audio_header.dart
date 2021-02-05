import 'package:audioplayers/audioplayers.dart';
import 'package:convertyoutubeplayer/models/cache_models/audio_model.dart';
import 'package:convertyoutubeplayer/provider/service_provider.dart';
import 'package:convertyoutubeplayer/services/player_service.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class AudioHeader extends StatefulWidget {
  AudioHeader({Key key}) : super(key: key);

  @override
  _AudioHeaderState createState() => _AudioHeaderState();
}

class _AudioHeaderState extends State<AudioHeader> {
  PlayerService _playerService = ServiceProvider.get();

  AudioModel _currentAudio;
  var _isPlaying = false;

  @override
  void initState() {
    this._playerService.addListenerOnAudioChange(this._onChangeAudio);
    this
        ._playerService
        .addListenerOnAudioStatusChange(this._onAudioStatusChange);
    super.initState();
  }

  @override
  void dispose() {
    this._playerService.removeListenerOnAudioChange(this._onChangeAudio);
    this
        ._playerService
        .removeListenerOnAudioStatusChange(this._onAudioStatusChange);
    super.dispose();
  }

  _onChangeAudio(AudioModel audio) {
    setState(() {
      this._currentAudio = audio;
    });
  }

  _onAudioStatusChange(AudioModel audio, AudioPlayerState state) {
    setState(() {
      switch (state) {
        case AudioPlayerState.PLAYING:
          this._isPlaying = true;
          break;
        case AudioPlayerState.COMPLETED:
        case AudioPlayerState.PAUSED:
        case AudioPlayerState.STOPPED:
          this._isPlaying = false;
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(48, 71, 94, 1),
        border: Border(
          bottom: BorderSide(width: 1.0, color: Color.fromRGBO(34, 40, 49, 1)),
        ),
      ),
      height: 128,
      child: Row(
        children: [
          FlatButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (this._isPlaying)
                this._playerService.pauseAudio();
              else
                this._playerService.playAudio();
            },
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: this._currentAudio != null
                      ? Image.network(
                          _currentAudio.thumbnailUrl,
                          width: 128,
                          height: 128,
                        )
                      : SvgPicture.asset(
                          "assets/album-24px.svg",
                          color: Colors.black,
                          width: 128,
                          height: 128,
                        ),
                ),
                Container(
                  width: 128,
                  height: 128,
                  child: Stack(
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          this._isPlaying
                              ? "assets/pause-symbol.svg"
                              : "assets/play-button-arrowhead.svg",
                          color: Colors.white,
                          height: 38,
                        ),
                      ),
                      Center(
                        child: SvgPicture.asset(
                          this._isPlaying
                              ? "assets/pause-symbol.svg"
                              : "assets/play-button-arrowhead.svg",
                          color: Colors.black,
                          height: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(this._currentAudio?.title ?? "Titre",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )),
                          Text("Autheur",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              )),
                          Text(
                              this._currentAudio?.playlist?.title ?? "Playlist",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/play-button-arrowhead.svg",
                      color: Colors.white,
                      height: 32,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
