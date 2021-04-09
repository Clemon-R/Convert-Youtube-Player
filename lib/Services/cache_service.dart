import 'dart:convert';
import 'dart:io';

import 'package:convertyoutubeplayer/models/cache_models/cache_model.dart';
import 'package:convertyoutubeplayer/services/iservice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CacheService extends IService {
  static const String TAG = "CacheService";

  Directory? _homeDirectory;
  String _fileName = "cache.conf";
  CacheModel _content = CacheModel();
  CacheModel get content => this._content;

  CacheService() {
    print("$TAG: Init...");
    print("$TAG: Initiated");
  }

  _loadHomeDirectory() async {
    if (this._homeDirectory == null) {
      this._homeDirectory = await getApplicationDocumentsDirectory();
      if (!await this._homeDirectory!.exists())
        this._homeDirectory!.create(recursive: true);
      print("$TAG: Home directory loaded");
    }
  }

  loadCache() async {
    print("$TAG: Loading cache...");
    await this._loadHomeDirectory();
    var file = File(p.join(this._homeDirectory!.path, this._fileName));
    if (!await file.exists()) {
      print("$TAG: No cache found");
      return;
    }
    var content = await file.readAsString();
    print("$TAG: Json content\n$content");
    var json = jsonDecode(content);
    this._content = CacheModel.fromJson(json);
    print("$TAG: Cache loaded");
  }

  saveCache() async {
    print("$TAG: Saving cache...");
    await this._loadHomeDirectory();
    var file = File(p.join(this._homeDirectory!.path, this._fileName));
    if (await file.exists()) {
      print("$TAG: Removing old cache");
      try {
        await file.delete();
      } catch (FileSystemException) {}
    }
    var content = this._content.toJson();
    print("$TAG: Json content\n$content");
    var json = jsonEncode(content);
    print("$TAG: Json\n$json");
    await file.writeAsString(json);
    print("$TAG: Cache saved");
  }
}
