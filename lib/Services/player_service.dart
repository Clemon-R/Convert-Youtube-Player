import 'package:audioplayers/audioplayers.dart';
import 'package:convertyoutubeplayer/models/cache_models/audio_model.dart';
import 'package:convertyoutubeplayer/services/base_service.dart';

class PlayerService extends BaseService {
  List<void Function(AudioModel audio)> _onAudioChange =
      List.empty(growable: true);
  List<void Function(AudioModel audio, AudioPlayerState state)>
      _onAudioStatusChange = List.empty(growable: true);
  List<void Function(double seconds)> _onAudioDurationChange =
      List.empty(growable: true);
  List<void Function(dynamic event)> _onAudioPositionChange =
      List.empty(growable: true);

  AudioModel _currentAudio = null;
  final _audioPlayer = AudioPlayer();

  PlayerService() {
    _onAudioChange.add((audio) {
      this._audioPlayer.setUrl(audio.pathFile, isLocal: true);
    });
    this._audioPlayer.onDurationChanged.listen((event) {
      this
          ._onAudioDurationChange
          .forEach((handler) => handler(event.inSeconds.toDouble()));
    });
    this._audioPlayer.onAudioPositionChanged.listen((event) {
      this._onAudioPositionChange.forEach((handler) => handler(event));
    });
  }

  changeAudio(AudioModel audio) {
    this._currentAudio = audio;
    this._onAudioChange.forEach((handler) => handler(audio));
  }

  changeAudioStatus(AudioModel audio, AudioPlayerState state) {
    this._onAudioStatusChange.forEach((handler) => handler(audio, state));
  }

  changeSeek(int seconds) {
    this._audioPlayer.seek(Duration(seconds: seconds));
  }

  play() async {
    if (this._currentAudio == null) return;
    await this._audioPlayer.resume();
    this.changeAudioStatus(this._currentAudio, this._audioPlayer.state);
  }

  pause() async {
    if (this._currentAudio == null) return;
    await this._audioPlayer.pause();
    this.changeAudioStatus(this._currentAudio, this._audioPlayer.state);
  }

  AudioModel getCurrentAudio() {
    return this._currentAudio;
  }

  addListenerOnAudioPositionChange(void Function(dynamic event) handler) {
    if (!_onAudioPositionChange.contains(handler))
      this._onAudioPositionChange.add(handler);
  }

  removeListenerOnAudioPositionChange(void Function(dynamic event) handler) {
    if (_onAudioPositionChange.contains(handler))
      this._onAudioPositionChange.remove(handler);
  }

  addListenerOnAudioDurationChange(void Function(double seconds) handler) {
    if (!_onAudioDurationChange.contains(handler))
      this._onAudioDurationChange.add(handler);
  }

  removeListenerOnAudioDurationChange(void Function(double seconds) handler) {
    if (_onAudioDurationChange.contains(handler))
      this._onAudioDurationChange.remove(handler);
  }

  addListenerOnAudioChange(void Function(AudioModel audio) handler) {
    if (!_onAudioChange.contains(handler)) this._onAudioChange.add(handler);
  }

  removeListenerOnAudioChange(void Function(AudioModel audio) handler) {
    if (_onAudioChange.contains(handler)) this._onAudioChange.remove(handler);
  }

  addListenerOnAudioStatusChange(
      void Function(AudioModel audio, AudioPlayerState state) handler) {
    if (!_onAudioStatusChange.contains(handler))
      this._onAudioStatusChange.add(handler);
  }

  removeListenerOnAudioStatusChange(
      void Function(AudioModel audio, AudioPlayerState state) handler) {
    if (_onAudioStatusChange.contains(handler))
      this._onAudioStatusChange.remove(handler);
  }
}
