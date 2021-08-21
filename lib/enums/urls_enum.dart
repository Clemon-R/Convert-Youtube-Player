import 'package:youtekmusic/enums/end_point_enum.dart';

enum UrlsEnum { baseUrl, csrf, start, check, browser }

extension UrlsEnumExt on UrlsEnum {
  String toUrlString(EndPointEnum domain) {
    final mp3Convert = "https://mp3-youtube.download";
    final youtube = "https://m.youtube.com";
    switch (this) {
      case UrlsEnum.baseUrl:
        switch (domain) {
          case EndPointEnum.Mp3Convert:
            return mp3Convert;
          case EndPointEnum.Youtube:
            return youtube;
        }
      case UrlsEnum.csrf:
        return "$mp3Convert/csrf";
      case UrlsEnum.start:
        return "$mp3Convert/download/start";
      case UrlsEnum.check:
        return "$mp3Convert/download/:id";
      case UrlsEnum.browser:
        return "$mp3Convert/fr/your-audio-converter";
    }
  }
}
