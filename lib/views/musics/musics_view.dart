import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtekmusic/constant/strings.dart';
import 'package:youtekmusic/constant/theme_colors.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/player_service.dart';
import 'package:youtekmusic/views/musics/bloc/musics_bloc.dart';

class MusicsView extends StatefulWidget {
  MusicsView({Key? key, this.playlistName}) : super(key: key);

  final String? playlistName;

  @override
  _MusicsViewState createState() => _MusicsViewState();
}

class _MusicsViewState extends State<MusicsView> {
  late final MusicsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        this._bloc = MusicsBloc(
            playlistName: this.widget.playlistName ?? Strings.DEFAULT_PLAYLIST);
        return this._bloc;
      },
      child: BlocBuilder<MusicsBloc, MusicsState>(
        builder: (context, state) {
          if (state is MusicsInitiated)
            return this._buildView(context, state);
          else if (state is MusicsInitial)
            return Container(); //TODO : Loading screen
          else
            return Container(); //TODO : Error screen
        },
      ),
    );
  }

  Widget _buildView(BuildContext context, MusicsInitiated state) {
    return Container(
        color: ThemeColors.darkBlue,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.playlist.musics.length,
                  itemBuilder: (context, index) {
                    var audio = state.playlist.musics.values.elementAt(index);
                    return Container(
                      color: ThemeColors.lightBlue,
                      height: 60,
                      child: Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(0))),
                            child: Image.network(
                              audio.thumbnailUrl ?? "",
                            ),
                            onPressed: () {
                              this
                                  ._bloc
                                  .add(MusicsChangeCurrentMusic(audio: audio));
                            },
                          ),
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(EdgeInsets.all(8))),
                              child: SizedBox.expand(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(audio.title ?? "Title",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                    Text(audio.author ?? "Author",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        )),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                this._bloc.add(
                                    MusicsChangeCurrentMusic(audio: audio));
                              },
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.all(8),
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(16, 16),
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/delete-24px.svg",
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              this._bloc.add(MusicsDeleteMusic(audio: audio));
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
