import 'dart:io';

import 'package:convertyoutubeplayer/provider/service_provider.dart';
import 'package:convertyoutubeplayer/services/cache_service.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  static const String TAG = "CacheService";

  SettingsView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  CacheService _cacheService = ServiceProvider.get();
  bool _isBusy = false;

  _deleteAllAudiosFile() async {
    print("${SettingsView.TAG}: Deleting every audio file...");
    setState(() {
      this._isBusy = true;
    });
    for (var audio in _cacheService.content.audios.values) {
      var file = File(audio.pathFile);

      if (!await file.exists()) continue;
      print("${SettingsView.TAG}: Deleting ${audio.title}...");
      await file.delete();
    }
    setState(() {
      this._isBusy = false;
    });
    print("${SettingsView.TAG}: All audio file has been deleted");
  }

  _deleteAllAudiosAndPlaylist() async {
    print("${SettingsView.TAG}: Deleting the cache...");
    setState(() {
      this._isBusy = true;
    });
    _cacheService.content.audios.clear();
    await _cacheService.saveCache();
    setState(() {
      this._isBusy = false;
    });
    print("${SettingsView.TAG}: Cache empty");
  }

  _deleteEverythingFromTheCache() async {
    await this._deleteAllAudiosFile();
    await this._deleteAllAudiosAndPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Paramètre du Cache",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Container(
                height: 1,
                color: Colors.white,
              ),
            ),
            Table(
              children: [
                TableRow(children: [
                  TableCell(
                    child: Text("Vider le cache sans supprimer les musiques",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    verticalAlignment: TableCellVerticalAlignment.middle,
                  ),
                  TableCell(
                      child: FlatButton(
                          onPressed: () async {
                            await this._deleteAllAudiosAndPlaylist();
                          },
                          textColor: Colors.white,
                          color: Color.fromRGBO(240, 84, 84, 1),
                          child: Text("Vider le cache"))),
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text("Vider le cache sans supprimer les playlist",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    verticalAlignment: TableCellVerticalAlignment.middle,
                  ),
                  TableCell(
                      child: FlatButton(
                          onPressed: () async {
                            await this._deleteAllAudiosFile();
                          },
                          textColor: Colors.white,
                          color: Color.fromRGBO(240, 84, 84, 1),
                          child: Text("Vider le cache"))),
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text("Vide entièrement le cache",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    verticalAlignment: TableCellVerticalAlignment.middle,
                  ),
                  TableCell(
                      child: FlatButton(
                          onPressed: () async {
                            await this._deleteEverythingFromTheCache();
                          },
                          textColor: Colors.white,
                          color: Color.fromRGBO(240, 84, 84, 1),
                          child: Text("Vider le cache"))),
                ]),
              ],
            ),
            Text("Powered by mp3-youtube.download © 2021 - Raphaël Goulmot",
                style: TextStyle(color: Colors.grey))
          ],
        ),
      )
    ];
    if (this._isBusy)
      content.add(
        Container(
          color: Color.fromRGBO(34, 40, 49, 0.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Veuillez patienter...",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    return Container(
      color: Color.fromRGBO(34, 40, 49, 1.0),
      child: Stack(
        children: content,
      ),
    );
  }
}
