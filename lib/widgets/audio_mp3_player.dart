import 'package:audioplayers/audioplayers.dart';
import 'package:convertyoutubeplayer/models/cache_models/audio_model.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class AudioMp3Player extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this case nothing) provided by the parent and used
  // by the build  method of the State. Fields in a Widget
  // subclass are always marked "final".
  _AudioMp3PlayerState currentState;

  final String title;

  AudioMp3Player({Key key, this.title}) : super(key: key);

  loadAudio(AudioModel audio) {
    if (this.currentState == null)
      throw Exception("La vue n'a pas été générer");
    this.currentState.loadAudio(audio);
  }

  @override
  _AudioMp3PlayerState createState() {
    this.currentState = _AudioMp3PlayerState();
    return this.currentState;
  }
}

class _AudioMp3PlayerState extends State<AudioMp3Player> {
  final _audioPlayer = AudioPlayer();

  String _leftDuration = "0:00";
  double _maxProgress = 0;
  String _duration = "0:00";
  double _progress = 0;

  //String _msg;
  AudioModel currentAudio;
  List<AudioModel> playlist = List.empty();

  _AudioMp3PlayerState({this.currentAudio, this.playlist});

  loadAudio(AudioModel audio) {
    setState(() {
      this.currentAudio = audio;
      this._audioPlayer.setUrl(audio.pathFile, isLocal: true);
    });
  }

  @override
  void initState() {
    super.initState();

    this._audioPlayer.onDurationChanged.listen((event) {
      setState(() {
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
  }

  _pause() async {
    await this._audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(48, 71, 94, 1),
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
                    color: this.currentAudio == null
                        ? Color.fromRGBO(221, 221, 221, 1)
                        : Colors.white,
                    semanticsLabel: 'up arrow',
                    width: 32,
                    height: 32,
                    placeholderBuilder: (BuildContext context) => Container(
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                  onPressed: this.currentAudio == null
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
                      Text(this.currentAudio?.title ?? "Title",
                          style: TextStyle(color: Colors.white)),
                      Text(this.currentAudio?.author ?? "Autheur",
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
