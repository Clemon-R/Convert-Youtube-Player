import 'package:convertyoutubeplayer/views/download_view.dart';
import 'package:convertyoutubeplayer/views/musics_view.dart';
import 'package:convertyoutubeplayer/views/playlist_view.dart';
import 'package:convertyoutubeplayer/views/settings_view.dart';
import 'package:convertyoutubeplayer/widgets/audio_header.dart';
import 'package:convertyoutubeplayer/widgets/audio_mp3_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainView extends StatefulWidget {
  MainView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  AudioMp3Player _audioPlayer;
  int _currentIndex = 1;

  Widget _buildIcon(Widget icon, String text, int index) => Container(
        width: double.infinity,
        height: kBottomNavigationBarHeight,
        child: Material(
          color: index == this._currentIndex
              ? Color.fromRGBO(48, 71, 94, 1)
              : Color.fromRGBO(34, 40, 49, 1.0),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                AnimatedDefaultTextStyle(
                  child: Text(text),
                  style: index == this._currentIndex
                      ? TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        )
                      : TextStyle(
                          color: Colors.white.withAlpha(150),
                          fontSize: 10,
                        ),
                  duration: Duration(milliseconds: 200),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                this._currentIndex = index;
              });
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (this._audioPlayer == null) this._audioPlayer = AudioMp3Player();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: IndexedStack(
                  index: this._currentIndex,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          AudioHeader(),
                          Expanded(child: MusicsView()),
                        ],
                      ),
                    ),
                    PlaylistView(),
                    DownloadView(),
                    SettingsView(),
                  ],
                ),
              ),
            ),
            this._audioPlayer,
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Color.fromRGBO(34, 40, 49, 1.0),
          selectedFontSize: 0,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(48, 71, 94, 1),
                icon: this._buildIcon(
                    SvgPicture.asset(
                      "assets/audiotrack-24px.svg",
                      color: Colors.white,
                    ),
                    "Musiques",
                    0),
                label: ""),
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(48, 71, 94, 1),
                icon: this._buildIcon(
                    SvgPicture.asset(
                      "assets/playlist_play-24px.svg",
                      color: Colors.white,
                    ),
                    "Playlist",
                    1),
                label: ""),
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(48, 71, 94, 1),
                icon: this._buildIcon(
                    SvgPicture.asset(
                      "assets/get_app-24px.svg",
                      color: Colors.white,
                    ),
                    "Téléchargement",
                    2),
                label: ""),
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(48, 71, 94, 1),
                icon: this._buildIcon(
                    SvgPicture.asset(
                      "assets/settings-24px.svg",
                      color: Colors.white,
                    ),
                    "Paramètres",
                    3),
                label: ""),
          ],
          currentIndex: this._currentIndex,
        ),
      ),
    );
  }
}
