import 'dart:core';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtekmusic/constant/theme_colors.dart';
import 'package:youtekmusic/models/cache_models/audio_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/player_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  AudioPlayerWidget({Key? key}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final _playerService = ServicesProvider.get<PlayerService>();

  String _leftDuration = "0:00";
  double _maxProgress = 0;
  String _duration = "0:00";
  double? _progress = 0;

  AudioModel? _currentAudio;
  bool _isPlaying = false;

  @override
  void initState() {
    this._playerService.addListenerOnAudioChange(this._onAudioChange);
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
    this._playerService.removeListenerOnAudioChange(this._onAudioChange);
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

  _onAudioChange(AudioModel audio) {
    setState(() {
      this._currentAudio = audio;
    });
  }

  _onAudioStatusChange(AudioModel? audio, PlayerState state) {
    setState(() {
      switch (state) {
        case PlayerState.PLAYING:
          this._isPlaying = true;
          break;
        case PlayerState.COMPLETED:
        case PlayerState.PAUSED:
        case PlayerState.STOPPED:
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
      color: ThemeColors.lightBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SliderTheme(
            data: SliderThemeData(
                activeTrackColor: Color.fromRGBO(240, 84, 84, 1),
                inactiveTrackColor: Color.fromRGBO(240, 84, 84, 0.5),
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 5.0,
                thumbColor: Colors.redAccent,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                overlayColor: Colors.redAccent,
                overlayShape: RoundSliderThumbShape(enabledThumbRadius: 0)),
            child: Slider(
              value: _progress!,
              min: 0,
              max: this._maxProgress,
              label: this._duration.toString(),
              divisions:
                  this._maxProgress.toInt() > 0 ? this._maxProgress.toInt() : 1,
              onChanged: (value) {
                setState(() {
                  this._progress = value;
                });
                this._playerService.changeSeek(value.toInt());
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                    minimumSize: MaterialStateProperty.all(Size(32, 32)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: SvgPicture.asset(
                    this._isPlaying
                        ? "assets/pause-symbol.svg"
                        : "assets/play-button-arrowhead.svg",
                    color: this._currentAudio == null
                        ? Color.fromRGBO(221, 221, 221, 1)
                        : Colors.white,
                    semanticsLabel: 'up arrow',
                    width: 32,
                    height: 32,
                    placeholderBuilder: (BuildContext context) => Container(
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                  onPressed: this._currentAudio == null
                      ? null
                      : () {
                          if (!this._isPlaying)
                            this._playerService.play();
                          else
                            this._playerService.pause();
                        }),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(this._currentAudio?.title ?? "Title",
                          style: TextStyle(color: Colors.white)),
                      Text(this._currentAudio?.author ?? "Autheur",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),
              Text(this._leftDuration,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
