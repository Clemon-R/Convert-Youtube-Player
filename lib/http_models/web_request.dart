import 'package:convertyoutubeplayer/enums/HeaderDomainEnum.dart';
import 'package:convertyoutubeplayer/http_models/convert_mp3/start_convert_music_request.dart';
import 'package:convertyoutubeplayer/utils/reflector.dart';
//import 'package:reflectable/mirrors.dart';

class WebRequest<U, T> {
  final String url;
  final HeaderDomainEnum domain = HeaderDomainEnum.Mp3Convert;
  U body;
  T Function(Map<String, dynamic> json) onDone = (json) {
    /*ClassMirror template = reflector.reflectType(T);
    template.newInstance("", []);
    if (template is StartConvertMusicRequest) {
      print("OK !!!!");
    }*/
    return null;
  };
  T Function(Map<String, dynamic> json) onSuccess;
  T Function(Map<String, dynamic> json) onFail;

  WebRequest({this.url, this.body, this.onSuccess, this.onFail});
}
