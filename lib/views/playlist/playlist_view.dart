import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtekmusic/constant/theme_colors.dart';
import 'package:youtekmusic/views/musics/musics_view.dart';
import 'package:youtekmusic/views/playlist/bloc/playlist_bloc.dart';

class PlaylistView extends StatefulWidget {
  PlaylistView({Key? key}) : super(key: key);

  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  late final PlaylistBloc _bloc;
  //PlaylistModel? _currentPlaylist;

  // void _goToPlaylistList() {
  //   setState(() {
  //     this._currentPlaylist = null;
  //   });
  // }

  // void _goToPlaylist(PlaylistModel playlist) {
  //   setState(() {
  //     this._currentPlaylist = playlist;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        this._bloc = PlaylistBloc();
        return this._bloc;
      },
      child: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistInitial)
            return Container(); //TODO : Loading screen
          else if (state is PlaylistInitiated)
            return IndexedStack(
              index: state.currentPlaylist == null ? 0 : 1,
              children: [
                _buildPlaylistListViewContent(state),
                _currentPlaylistView(state),
              ],
            );
          else
            return Container(); //TODO : Error screen
        },
      ),
    );
  }

  Widget _buildPlaylistListViewContent(PlaylistInitiated state) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: state.playlists.length,
        itemBuilder: (context, index) {
          var playlist = state.playlists[index];
          var firstAudio = playlist.musics.values.first;
          return Container(
            color: ThemeColors.lightBlue,
            height: 60,
            child: Row(
              children: [
                TextButton(
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0))),
                  child: Image.network(
                    firstAudio.thumbnailUrl ?? "",
                  ),
                  onPressed: () {
                    this._bloc.add(PlaylistChangePlaylist(playlist: playlist));
                    //this._goToPlaylist(playlist);
                  },
                ),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(0))),
                    child: SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(playlist.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              )),
                          Text("${playlist.musics.length} Musiques",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              )),
                        ],
                      ),
                    ),
                    onPressed: () {
                      this
                          ._bloc
                          .add(PlaylistChangePlaylist(playlist: playlist));
                      //this._goToPlaylist(playlist);
                    },
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                      minimumSize: MaterialStateProperty.all(Size(16, 16))),
                  child: SvgPicture.asset(
                    "assets/delete-24px.svg",
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          );
        });
  }

  Widget _currentPlaylistView(PlaylistInitiated state) {
    if (state.currentPlaylist == null)
      return Container(); // TODO : Error screen
    return Column(
      children: [
        Container(
          height: 32,
          decoration: const BoxDecoration(
            color: ThemeColors.lightBlue,
            border: Border(
              bottom: BorderSide(width: 1.0, color: ThemeColors.darkBlue),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              this._bloc.add(PlaylistChangePlaylist(playlist: null));
              //this._goToPlaylistList();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: SvgPicture.asset(
                    "assets/arrow_back_ios_new-24px.svg",
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.currentPlaylist!.title,
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: MusicsView(playlistName: state.currentPlaylist!.title)),
      ],
    );
  }
}
