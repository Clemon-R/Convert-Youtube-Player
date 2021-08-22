import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtekmusic/models/cache_models/cache_model.dart';
import 'package:youtekmusic/services/base_service.dart';

class CacheService extends BaseService {
  static const String TAG = "CacheService";

  CacheModel _content = CacheModel(playlists: {});
  CacheModel get content => this._content;

  bool _isReady = false;
  bool get isReady => this._isReady;

  late final SharedPreferences _prefs;

  _initService() async {
    print("$TAG: Init...");
    this._prefs = await SharedPreferences.getInstance();
    this._isReady = true;
    print("$TAG: Initiated");
  }

  Future loadCache() async {
    if (!this._isReady) {
      await this._initService();
    }

    try {
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
    } catch (e) {
      print(e);
    }
  }

  Future saveCache() async {
    if (!this._isReady) {
      await this._initService();
    }

    try {
      print("$TAG: Saving cache...");
      var content = this._content.toJson();
      print("$TAG: Json content\n$content");
      var json = jsonEncode(content);
      print("$TAG: Json\n$json");
      this._prefs.setString(TAG, json);
      print("$TAG: Cache saved");
    } catch (e) {
      print(e);
    }
  }
}
