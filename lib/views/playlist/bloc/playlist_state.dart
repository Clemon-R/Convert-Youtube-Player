part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {}

class PlaylistInitiated extends PlaylistState {
  final List<PlaylistModel> playlists;
  final PlaylistModel? currentPlaylist;

  PlaylistInitiated({required this.playlists, required this.currentPlaylist});
}

class PlaylistError extends PlaylistState {}
