part of 'musics_bloc.dart';

@immutable
abstract class MusicsState {}

class MusicsInitial extends MusicsState {}

class MusicsInitiated extends MusicsState {
  final PlaylistModel playlist;

  MusicsInitiated({required this.playlist});
}

class MusicsError extends MusicsState {}
