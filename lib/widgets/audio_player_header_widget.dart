import 'package:audioplayers/audioplayers.dart';
import 'package:youtekmusic/constant/theme_colors.dart';
import 'package:youtekmusic/models/cache_models/audio_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/player_service.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter_svg/svg.dart';

class AudioPlayerHeaderWidget extends StatefulWidget {
  AudioPlayerHeaderWidget({Key? key}) : super(key: key);

  @override
  _AudioPlayerHeaderWidgetState createState() =>
      _AudioPlayerHeaderWidgetState();
}

class _AudioPlayerHeaderWidgetState extends State<AudioPlayerHeaderWidget> {
  final _playerService = ServicesProvider.get<PlayerService>();

  double _maxProgress = 0;
  String _duration = "0:00";
  double? _progress = 0;

  AudioModel? _currentAudio;
  bool _isPlaying = false;

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
      this._duration =
          "${(event.inSeconds / 60).floor()}:${seconds <= 9 ? '0' : ''}$seconds";
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
      decoration: const BoxDecoration(
        color: ThemeColors.lightBlue,
        border: Border(
          bottom: BorderSide(width: 1.0, color: ThemeColors.darkBlue),
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
                value: _progress! > this._maxProgress
                    ? this._maxProgress
                    : _progress!,
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
                          _currentAudio!.thumbnailUrl ?? "",
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
                              GestureDetector(
                                onTap: () => this._playerService.playPrevious(),
                                child: SvgPicture.asset(
                                  "assets/skip_previous-24px.svg",
                                  color: Colors.white,
                                  height: 32,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
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
                              GestureDetector(
                                onTap: () => this._playerService.playNext(),
                                child: SvgPicture.asset(
                                  "assets/skip_next-24px.svg",
                                  color: Colors.white,
                                  height: 32,
                                ),
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
