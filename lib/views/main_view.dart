import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtekmusic/constant/theme_colors.dart';
import 'package:youtekmusic/views/download/download_view.dart';
import 'package:youtekmusic/views/musics/musics_view.dart';
import 'package:youtekmusic/views/playlist/playlist_view.dart';
import 'package:youtekmusic/views/settings_view.dart';
import 'package:youtekmusic/widgets/audio_player_header_widget.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  final _audioPlayer = AudioPlayerHeaderWidget();

  late final List<Widget> _tabViews;
  int _currentViewIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _fadingAnimation;
  double _animationOpacity = 1;

  void initState() {
    this._tabViews = [
      MusicsView(),
      PlaylistView(),
      DownloadView(),
      SettingsView(),
    ];
    this._animationController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: Duration(milliseconds: 250),
    );
    this._fadingAnimation =
        Tween(begin: 0.0, end: 1.0).animate(this._animationController)
          ..addListener(() {
            setState(() {
              this._animationOpacity = this._fadingAnimation.value;
            });
          });
    super.initState();
  }

  List<Widget> _getAnimatedTabView(List<Widget> tabViews) {
    List<Widget> result = [];

    tabViews.forEach((element) {
      result.add(Opacity(
        opacity: this._animationOpacity,
        child: element,
      ));
    });
    return result;
  }

  int _getViewIndex<T extends Widget>() {
    return this._tabViews.indexWhere((element) => element is T);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColors.darkBlue,
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: IndexedStack(
                  index: this._currentViewIndex,
                  children: this._getAnimatedTabView(this._tabViews),
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
            this._buildTabMenuItem<MusicsView>(
                iconAssetPath: "assets/audiotrack-24px.svg", title: "Musiques"),
            this._buildTabMenuItem<PlaylistView>(
                iconAssetPath: "assets/playlist_play-24px.svg",
                title: "Playlist"),
            this._buildTabMenuItem<DownloadView>(
                iconAssetPath: "assets/get_app-24px.svg",
                title: "Téléchargement"),
            this._buildTabMenuItem<SettingsView>(
                iconAssetPath: "assets/settings-24px.svg", title: "Paramètres"),
          ],
          currentIndex: this._currentViewIndex,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildTabMenuItem<T extends Widget>(
      {required String iconAssetPath, required String title}) {
    return BottomNavigationBarItem(
        backgroundColor: ThemeColors.lightBlue,
        icon: this._buildTabMenuButton(
            SvgPicture.asset(
              iconAssetPath,
              color: Colors.white,
            ),
            title,
            this._getViewIndex<T>()),
        label: "");
  }

  Widget _buildTabMenuButton(Widget icon, String text, int index) => Container(
        width: double.infinity,
        height: kBottomNavigationBarHeight,
        child: Material(
          color: index == this._currentViewIndex
              ? ThemeColors.lightBlue
              : ThemeColors.darkBlue,
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                AnimatedDefaultTextStyle(
                  child: Text(text),
                  style: index == this._currentViewIndex
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
              if (this._currentViewIndex == index) return;
              setState(() {
                this._currentViewIndex = index;
              });
              this._animationController.reset();
              this._animationController.forward();
            },
          ),
        ),
      );
}
