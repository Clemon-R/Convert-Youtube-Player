import 'package:audioplayers/audioplayers.dart';
import 'package:convertyoutubeplayer/models/cache_models/audio_model.dart';
import 'package:convertyoutubeplayer/provider/services_provider.dart';
import 'package:convertyoutubeplayer/services/player_service.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class AudioHeader extends StatefulWidget {
  AudioHeader({Key? key}) : super(key: key);

  @override
  _AudioHeaderState createState() => _AudioHeaderState();
}

class _AudioHeaderState extends State<AudioHeader> {
  PlayerService _playerService = ServicesProvider.get();

  String _leftDuration = "0:00";
  double _maxProgress = 0;
  String _duration = "0:00";
  double? _progress = 0;

  AudioModel? _currentAudio;
  var _isPlaying = false;

  @override
  void initState() {
    this._playerService.addListenerOnAudioChange(this._onChangeAudio);
    this
        ._playerService
        .addListenerOnAudioStatusChange(this._onAudioStatusChange);
    this
        ._playerService
        .addListenerOnAudioDurationChange(this._onAudioDurationChange);
    this
        ._playerService
        .addListenerOnAudioPositionChange(this._onAudioPositionChange);
    super.initState();
  }

  @override
  void dispose() {
    this._playerService.removeListenerOnAudioChange(this._onChangeAudio);
    this
        ._playerService
        .removeListenerOnAudioStatusChange(this._onAudioStatusChange);
    this
        ._playerService
        .removeListenerOnAudioDurationChange(this._onAudioDurationChange);
    this
        ._playerService
        .removeListenerOnAudioPositionChange(this._onAudioPositionChange);
    super.dispose();
  }

  _onAudioPositionChange(dynamic event) {
    setState(() {
      var seconds = event.inSeconds % 60;
      var left = this._maxProgress - event.inSeconds;
      var leftseconds = left.toInt() % 60;
      this._duration =
          "${(event.inSeconds / 60).floor()}:${seconds <= 9 ? '0' : ''}$seconds";
      this._leftDuration =
          "${(left / 60).floor()}:${leftseconds <= 9 ? '0' : ''}$leftseconds";
      this._progress = event.inSeconds.toDouble();
    });
  }

  _onAudioDurationChange(double seconds) {
    setState(() {
      this._maxProgress = seconds;
    });
  }

  _onChangeAudio(AudioModel audio) {
    setState(() {
      this._currentAudio = audio;
    });
  }

  _onAudioStatusChange(AudioModel? audio, AudioPlayerState state) {
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
      height: 150,
      child: Column(
        children: [
          Container(
            height: 15,
            child: SliderTheme(
              data: SliderThemeData(
                  activeTrackColor: Color.fromRGBO(240, 84, 84, 1),
                  inactiveTrackColor: Color.fromRGBO(240, 84, 84, 0.5),
                  activeTickMarkColor: Colors.transparent,
                  inactiveTickMarkColor: Colors.transparent,
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 15.0,
                  thumbColor: Colors.redAccent,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                  overlayColor: Colors.redAccent,
                  overlayShape: RoundSliderThumbShape(enabledThumbRadius: 0)),
              child: Slider(
                value: _progress!,
                min: 0,
                max: this._maxProgress,
                label: this._duration.toString(),
                divisions: this._maxProgress.toInt() > 0
                    ? this._maxProgress.toInt()
                    : 1,
                onChanged: (value) {
                  setState(() {
                    this._progress = value;
                  });
                  this._playerService.changeSeek(value.toInt());
                },
              ),
            ),
          ),
          Container(
            height: 134,
            child: Row(
              children: [
                Container(
                  color: Colors.white,
                  child: this._currentAudio != null
                      ? Image.network(
                          _currentAudio!.thumbnailUrl!,
                          width: 134,
                          height: 134,
                        )
                      : SvgPicture.asset(
                          "assets/album-24px.svg",
                          color: Colors.black,
                          width: 134,
                          height: 134,
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
                                    this._currentAudio?.playlist?.title ??
                                        "Playlist",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/skip_previous-24px.svg",
                                color: Colors.white,
                                height: 32,
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(0)),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(24, 24)),
                                ),
                                onPressed: () {
                                  if (this._isPlaying)
                                    this._playerService.pause();
                                  else
                                    this._playerService.play();
                                },
                                child: SvgPicture.asset(
                                  this._isPlaying
                                      ? "assets/pause-symbol.svg"
                                      : "assets/play-button-arrowhead.svg",
                                  color: Colors.white,
                                  height: 24,
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/skip_next-24px.svg",
                                color: Colors.white,
                                height: 32,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
