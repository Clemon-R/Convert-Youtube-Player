import 'package:convertyoutubeplayer/views/download_page.dart';
import 'package:convertyoutubeplayer/views/playlist_page.dart';
import 'package:convertyoutubeplayer/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
                          fontSize: 14,
                        )
                      : TextStyle(
                          color: Colors.white.withAlpha(150),
                          fontSize: 12,
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
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: this._currentIndex,
          children: [
            PlaylistPage(),
            DownloadPage(),
            SettingsPage(),
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
                      "assets/playlist_play-24px.svg",
                      color: Colors.white,
                    ),
                    "Playlist",
                    0),
                label: ""),
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(48, 71, 94, 1),
                icon: this._buildIcon(
                    SvgPicture.asset(
                      "assets/get_app-24px.svg",
                      color: Colors.white,
                    ),
                    "Téléchargement",
                    1),
                label: ""),
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(48, 71, 94, 1),
                icon: this._buildIcon(
                    SvgPicture.asset(
                      "assets/settings-24px.svg",
                      color: Colors.white,
                    ),
                    "Paramètres",
                    2),
                label: ""),
          ],
          currentIndex: this._currentIndex,
        ),
      ),
    );
  }
}
