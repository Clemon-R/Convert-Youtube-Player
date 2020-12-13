import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioMp3Player extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this case nothing) provided by the parent and used
  // by the build  method of the State. Fields in a Widget
  // subclass are always marked "final".
  AudioMp3Player({Key key, this.audioPath}) : super(key: key);

  final String audioPath;

  @override
  _AudioMp3PlayerState createState() => _AudioMp3PlayerState(this.audioPath);
}
class _AudioMp3PlayerState extends State<AudioMp3Player> {
  final String _audioPath;
  final _audioPlayer = AudioPlayer();
  String _msg;

  _AudioMp3PlayerState(this._audioPath);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.red[700],
              inactiveTrackColor: Colors.red[100],
              activeTickMarkColor: Colors.red[700],
              inactiveTickMarkColor: Colors.red[100],
              trackShape: RectangularSliderTrackShape(),
              trackHeight: 20.0,
              thumbColor: Colors.redAccent,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
              overlayColor: Colors.red.withAlpha(32),
              overlayShape: RoundSliderThumbShape(enabledThumbRadius: 12.0)
            ),
            child: Slider(
              value: 0,
              min: 0,
              max: 100,
              onChanged: (value){

              },
            ),
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
                onPressed: this._audioPath == null ? null : () async {
                  setState(() {
                    this._audioPlayer.play(this._audioPath);
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
                    this._audioPlayer.stop();
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
