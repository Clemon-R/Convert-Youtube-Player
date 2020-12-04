import 'package:convertyoutubeplayer/Services/token_service.dart';
import 'package:get_it/get_it.dart';

class Config {
  static const String TAG = "Config";
  static final GetIt getIt = GetIt.instance;

  static void initServices() {
    print("$TAG: Init services...");
    getIt.registerSingleton<TokenService>(TokenService());
    print("$TAG: Services initied");
  }
}
