import 'package:convertyoutubeplayer/cache_models/audio_model.dart';

class CacheModel {
  List<AudioModel> audios = List.empty();

  CacheModel();

  CacheModel.fromJson(Map<String, dynamic> json)
      : audios = (json['audios'] as List<dynamic>)
            .map((json) => AudioModel.fromJson(json))
            .toList();

  Map<String, dynamic> toJson() =>
      {'audios': audios.map((audio) => audio.toJson()).toList(growable: false)};
}
