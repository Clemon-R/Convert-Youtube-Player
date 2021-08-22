part of 'musics_bloc.dart';

@immutable
abstract class MusicsEvent {}

class MusicsChangePlaylist extends MusicsEvent {
  final String playlistName;

  MusicsChangePlaylist({required this.playlistName});
}

class MusicsChangeCurrentMusic extends MusicsEvent {
  final AudioModel audio;

  MusicsChangeCurrentMusic({required this.audio});
}

class MusicsDeleteMusic extends MusicsEvent {
  final AudioModel audio;

  MusicsDeleteMusic({required this.audio});
}
