import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class BlocsProvider {
  static const TAG = "BlocsProvider";

  static GetIt _getIt = GetIt.instance;

  static bool isSaved<T extends Bloc>() {
    return _getIt.isRegistered<T>();
  }

  static set<T extends Bloc>(T bloc) {
    _getIt.registerSingleton(bloc);
  }

  static T get<T extends Bloc>() {
    return _getIt.get<T>();
  }
}
