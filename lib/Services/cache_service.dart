import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtekmusic/models/cache_models/cache_model.dart';
import 'package:youtekmusic/services/iservice.dart';

class CacheService extends IService {
  static const String TAG = "CacheService";

  CacheModel _content = CacheModel();
  CacheModel get content => this._content;

  bool _isReady = false;
  bool get isReady => this._isReady;

  List<Function()> _onReady = [];
  List<Function()> get onReady => this._onReady;

  late final SharedPreferences _prefs;

  CacheService() {
    print("$TAG: Init...");
    SharedPreferences.getInstance().then((value) async {
      this._prefs = value;
      this._isReady = true;

      await this._loadCache();
      print("$TAG: Initiated");

      this._onReady.forEach((element) => element.call());
    });
  }

  _loadCache() async {
    if (!this._isReady) {
      print("$TAG(ERROR): Not ready yet");
      return;
    }

    print("$TAG: Loading cache...");
    var content = this._prefs.getString(TAG);
    if (content == null) {
      print("$TAG: No cache found");
      return;
    }
    print("$TAG: Json content\n$content");
    var json = jsonDecode(content);
    this._content = CacheModel.fromJson(json);
    print("$TAG: Cache loaded");
  }

  saveCache() async {
    if (!this._isReady) {
      print("$TAG(ERROR): Not ready yet");
      return;
    }

    print("$TAG: Saving cache...");
    var content = this._content.toJson();
    print("$TAG: Json content\n$content");
    var json = jsonEncode(content);
    print("$TAG: Json\n$json");
    this._prefs.setString(TAG, json);
    print("$TAG: Cache saved");
  }
}
