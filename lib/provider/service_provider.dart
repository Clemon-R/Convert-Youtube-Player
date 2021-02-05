import 'package:convertyoutubeplayer/services/base_service.dart';
import 'package:convertyoutubeplayer/services/cache_service.dart';
import 'package:convertyoutubeplayer/services/http_service.dart';
import 'package:convertyoutubeplayer/services/playlist_service.dart';
import 'package:convertyoutubeplayer/services/token_service.dart';
import 'package:get_it/get_it.dart';

class ServiceProvider {
  static GetIt _getIt = GetIt.instance;

  static Future<void> init() async {
    _getIt.registerSingleton(CacheService());
    _getIt.registerSingleton(PlaylistService(_getIt.get<CacheService>()));
    _getIt.registerSingleton(TokenService());
    _getIt.registerSingleton(HttpService(_getIt.get<TokenService>()));
  }

  static T get<T extends BaseService>() {
    return _getIt.get<T>();
  }
}
