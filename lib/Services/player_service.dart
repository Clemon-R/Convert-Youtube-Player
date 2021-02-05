import 'package:audioplayers/audioplayers.dart';
import 'package:convertyoutubeplayer/models/cache_models/audio_model.dart';
import 'package:convertyoutubeplayer/services/base_service.dart';

class PlayerService extends BaseService {
  List<void Function(AudioModel audio)> _onAudioChange =
      List.empty(growable: true);
  List<void Function(AudioModel audio, AudioPlayerState state)>
      _onAudioStatusChange = List.empty(growable: true);
  void Function(bool toPlay) _startOrStopAudio;

  AudioModel _currentAudio;

  void playAudio() {
    this._startOrStopAudio?.call(true);
  }

  void pauseAudio() {
    this._startOrStopAudio?.call(false);
  }

  void changeAudio(AudioModel audio) {
    this._currentAudio = audio;
    this._onAudioChange.forEach((handler) => handler(audio));
  }

  void changeAudioStatus(AudioModel audio, AudioPlayerState state) {
    this._onAudioStatusChange.forEach((handler) => handler(audio, state));
  }

  AudioModel getCurrentAudio() {
    return this._currentAudio;
  }

  void addListenerStartOrStopAudio(void Function(bool toPlay) handler) {
    if (_startOrStopAudio != handler) this._startOrStopAudio = handler;
  }

  void removeListenerStartOrStopAudio(void Function(bool toPlay) handler) {
    if (_startOrStopAudio == handler) this._startOrStopAudio = handler;
  }

  void addListenerOnAudioChange(void Function(AudioModel audio) handler) {
    if (!_onAudioChange.contains(handler)) this._onAudioChange.add(handler);
  }

  void removeListenerOnAudioChange(void Function(AudioModel audio) handler) {
    if (_onAudioChange.contains(handler)) this._onAudioChange.remove(handler);
  }

  void addListenerOnAudioStatusChange(
      void Function(AudioModel audio, AudioPlayerState state) handler) {
    if (!_onAudioStatusChange.contains(handler))
      this._onAudioStatusChange.add(handler);
  }

  void removeListenerOnAudioStatusChange(
      void Function(AudioModel audio, AudioPlayerState state) handler) {
    if (_onAudioStatusChange.contains(handler))
      this._onAudioStatusChange.remove(handler);
  }
}
