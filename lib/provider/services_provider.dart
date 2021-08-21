import 'package:async/async.dart';
import 'package:youtekmusic/repositories/mp3_converter_repository.dart';
import 'package:youtekmusic/repositories/youtube_repository.dart';
import 'package:youtekmusic/services/base_service.dart';
import 'package:youtekmusic/services/cache_service.dart';
import 'package:youtekmusic/services/http_service.dart';
import 'package:youtekmusic/services/player_service.dart';
import 'package:youtekmusic/services/playlist_service.dart';
import 'package:youtekmusic/services/token_service.dart';
import 'package:get_it/get_it.dart';

class ServicesProvider {
  static const TAG = "ServicesProvider";

  static final _getIt = GetIt.instance;
  static bool _isReady = false;
  static bool get isReady => _isReady;

  static prepareAllServices() {
    print("$TAG: Preparing all services...");
    _getIt.registerSingletonAsync(() async => CacheService());
    _getIt.registerSingletonAsync(() async => TokenService());
    _getIt.registerSingletonAsync(() async => PlayerService());

    _getIt.registerSingletonAsync(() async => PlaylistService(),
        dependsOn: [CacheService]);
    _getIt.registerSingletonAsync(() async => HttpService(),
        dependsOn: [TokenService]);

    _getIt.registerSingletonAsync(() async => Mp3ConverterRepository(),
        dependsOn: [HttpService]);
    _getIt.registerSingletonAsync(() async => YoutubeRepository(),
        dependsOn: [HttpService]);
    print("$TAG: All services prepared");
  }

  static Future<bool> initializeApp() async {
    print("$TAG: Initializing the app...");
    await _getIt.allReady();

    _getIt.get<CacheService>().loadCache();

    _isReady = true;
    return true;
  }

  static T get<T extends BaseService>() {
    return _getIt.get<T>();
  }
}
