import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class AudioMp3Player extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this case nothing) provided by the parent and used
  // by the build  method of the State. Fields in a Widget
  // subclass are always marked "final".
  AudioMp3Player(this.onNeedUrl, {Key key}) : super(key: key);

  final String Function() onNeedUrl;

  @override
  _AudioMp3PlayerState createState() => _AudioMp3PlayerState(this.onNeedUrl);
}
class _AudioMp3PlayerState extends State<AudioMp3Player> {
  final String Function() _onNeedUrl;
  final _audioPlayer = AudioPlayer();

  String _maxDuration = "0:00";
  double _maxProgress = 0;
  String _duration = "0:00";
  double _progress = 0;

  String _msg;

  _AudioMp3PlayerState(this._onNeedUrl);

  @override
  void initState() {
    super.initState();

    this._audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        this._maxDuration = "${(event.inSeconds / 60).floor()}:${event.inSeconds % 60}";
        this._maxProgress = event.inSeconds.toDouble();
      });
    });
    this._audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        this._duration = "${(event.inSeconds / 60).floor()}:${event.inSeconds % 60}";
        this._progress = event.inSeconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var path = this._onNeedUrl();
    if (path != null)
      this._audioPlayer.setUrl(path, isLocal: true);
    return Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.red[700],
              inactiveTrackColor: Colors.red[100],
              activeTickMarkColor: Colors.red[700],
              inactiveTickMarkColor: Colors.red[100],
              trackShape: RectangularSliderTrackShape(),
              trackHeight:5.0,
              thumbColor: Colors.redAccent,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.5),
              overlayColor: Colors.redAccent,
              overlayShape: RoundSliderThumbShape(enabledThumbRadius:2.5)
            ),
            child: Slider(
              value: _progress,
              min: 0,
              max: this._maxProgress,
              onChanged: (value){
                setState(() {
                  this._progress = value;
                });
                this._audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(this._duration),
              Text(this._maxDuration),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                disabledColor: Color.fromRGBO(255, 0, 0, 0.5),
                child: Text("Start"),
                onPressed: path == null ? null : () async {
                  setState(() {
                    this._audioPlayer.resume();
                    this._msg = "Playing...";
                  });
                },
              ),
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                disabledColor: Color.fromRGBO(255, 0, 0, 0.5),
                child: Text("Stop"),
                onPressed: () async {
                  setState(() {
                    this._audioPlayer.pause();
                    this._msg = "Stop";
                  });
                },
              ),
            ],
          )
        ],
      );
  }
}
