import 'package:audioplayers/audioplayers.dart';
import 'package:convertyoutubeplayer/cache_models/audio_model.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter_svg/svg.dart';

class AudioMp3Player extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this case nothing) provided by the parent and used
  // by the build  method of the State. Fields in a Widget
  // subclass are always marked "final".
  AudioMp3Player(this.onNeedAudio, {Key key}) : super(key: key);

  final AudioModel Function() onNeedAudio;

  @override
  _AudioMp3PlayerState createState() => _AudioMp3PlayerState(this.onNeedAudio);
}

class _AudioMp3PlayerState extends State<AudioMp3Player> {
  final AudioModel Function() _onNeedAudio;
  final _audioPlayer = AudioPlayer();

  String _leftDuration = "0:00";
  String _maxDuration = "0:00";
  double _maxProgress = 0;
  String _duration = "0:00";
  double _progress = 0;

  String _msg;

  _AudioMp3PlayerState(this._onNeedAudio);

  @override
  void initState() {
    super.initState();

    this._audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        var seconds = event.inSeconds % 60;
        this._maxDuration =
            "${(event.inSeconds / 60).floor()}:${seconds <= 9 ? '0' : ''}$seconds";
        this._maxProgress = event.inSeconds.toDouble();
      });
    });
    this._audioPlayer.onAudioPositionChanged.listen((event) {
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
    });
  }

  _play() async {
    await this._audioPlayer.resume();
    setState(() {
      this._msg = "Playing...";
    });
  }

  _pause() async {
    await this._audioPlayer.pause();
    setState(() {
      this._msg = "Stop";
    });
  }

  @override
  Widget build(BuildContext context) {
    var audio = this._onNeedAudio();
    if (audio != null) this._audioPlayer.setUrl(audio.pathFile, isLocal: true);
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SliderTheme(
            data: SliderThemeData(
                activeTrackColor: Colors.red[700],
                inactiveTrackColor: Colors.red[100],
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 5.0,
                thumbColor: Colors.redAccent,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                overlayColor: Colors.redAccent,
                overlayShape: RoundSliderThumbShape(enabledThumbRadius: 0)),
            child: Slider(
              value: _progress,
              min: 0,
              max: this._maxProgress,
              label: this._duration.toString(),
              divisions:
                  this._maxProgress.toInt() > 0 ? this._maxProgress.toInt() : 1,
              onChanged: (value) {
                setState(() {
                  this._progress = value;
                });
                this._audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlatButton(
                  color: Colors.transparent,
                  disabledColor: Colors.transparent,
                  minWidth: 32,
                  child: SvgPicture.asset(
                    this._audioPlayer.state == AudioPlayerState.PLAYING
                        ? "assets/pause-symbol.svg"
                        : "assets/play-button-arrowhead.svg",
                    color: audio == null ? Colors.grey : Colors.black,
                    semanticsLabel: 'up arrow',
                    width: 32,
                    height: 32,
                    placeholderBuilder: (BuildContext context) => Container(
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                  onPressed: audio == null
                      ? null
                      : () {
                          if (this._audioPlayer.state !=
                              AudioPlayerState.PLAYING)
                            this._play();
                          else
                            this._pause();
                        }),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(audio?.title ?? "Title"),
                      Text(audio?.author ?? "Autheur")
                    ],
                  ),
                ),
              ),
              Text(
                this._leftDuration,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
