part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistEvent {}

class PlaylistRefresh extends PlaylistEvent {}

class PlaylistChangePlaylist extends PlaylistEvent {}
