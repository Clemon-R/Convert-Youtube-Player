part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistEvent {}

class PlaylistRefresh extends PlaylistEvent {}

class PlaylistChangePlaylist extends PlaylistEvent {
  final PlaylistModel? playlist;

  PlaylistChangePlaylist({required this.playlist});
}
