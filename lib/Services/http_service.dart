import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:youtekmusic/models/rest_models/http_response_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/token_service.dart';
import 'package:youtekmusic/enums/end_point_enum.dart';
import 'package:youtekmusic/models/rest_models/irest_model.dart';
import 'package:youtekmusic/models/rest_models/http_download_request_model.dart';
import 'package:youtekmusic/models/rest_models/http_request_model.dart';
import 'package:youtekmusic/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HttpService extends BaseService {
  static const String TAG = "HttpService";

  final _tokenService = ServicesProvider.get<TokenService>();

  Map<String, String> headerSelector(EndPointEnum type) {
    Map<String, String> result = {};
    switch (type) {
      case EndPointEnum.Mp3Convert:
        result = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Origin': 'https://mp3-youtube.download'
        };
        if (this._tokenService.token != null)
          result["X-Token"] = _tokenService.token!;
        if (this._tokenService.xsrfToken != null)
          result["X-XSRF-Token"] = _tokenService.xsrfToken!;
        if (this._tokenService.cookie != null)
          result["cookie"] = _tokenService.cookie! + ";";
        break;
      case EndPointEnum.Youtube:
        break;
    }
    return result;
  }

  Future<HttpResponseModel<T>> post<U extends IRestModel, T extends IRestModel>(
      HttpRequestModel<U, T> request) async {
    print("$TAG: Post request on Url(${request.url})");
    var json = request.body != null ? jsonEncode(request.body) : null;
    print("$TAG: Post request Body($json)");

    var requestResult = await http.Client().post(Uri.parse(request.url),
        headers: headerSelector(request.domain), body: json);
    // requestResult.request?.headers.entries.forEach((element) {
    //   print("$TAG: Broken request ${element.key} ${element.value}");
    // });
    var body = requestResult.body;
    var headers = requestResult.headers;
    print("$TAG: Post response json\n$body");
    inspect(body);
    T? content;
    if (request.fromJson != null) {
      var jsonObj = jsonDecode(body);
      content = request.fromJson!(jsonObj);
    }
    print("$TAG: Post response obj");
    inspect(content);
    return HttpResponseModel(
        code: requestResult.statusCode,
        content: content,
        cookie: headers["set-cookie"]);
  }

  Future<HttpResponseModel<T>> get<U extends IRestModel, T extends IRestModel>(
      HttpRequestModel<U, T> request) async {
    print("$TAG: Get request on Url(${request.url})");
    var requestResult = await http.get(Uri.parse(request.url),
        headers: headerSelector(request.domain));
    var body = requestResult.body;
    var headers = requestResult.headers;
    print("$TAG: Get response json\n$body");
    T? content;
    if (request.fromJson != null) {
      var jsonObj = jsonDecode(body);
      content = request.fromJson!(jsonObj);
      print("$TAG: Get response obj");
      inspect(content);
    }
    return HttpResponseModel(
        code: requestResult.statusCode,
        content: content,
        cookie: headers["set-cookie"]);
  }

  Future<void> downloadFile(HttpDownloadRequestModel request) async {
    print("$TAG: Download Url(${request.url}), FileName(${request.fileName})");
    var httpClient = http.Client();
    var result = http.Request('GET', Uri.parse(request.url));
    Future<StreamedResponse> response;
    try {
      response = httpClient.send(result);
    } catch (e) {
      request.onFail!();
      return;
    }
    var dir = Directory(
        p.join((await getApplicationDocumentsDirectory()).path, request.path));
    if (!await dir.exists()) dir.create(recursive: true);

    var chunks = <List<int>>[];
    var downloaded = 0;
    late dynamic mainstream;
    mainstream = response.asStream().listen((http.StreamedResponse r) {
      late dynamic sub;
      sub = r.stream.listen((value) {
        try {
          chunks.add(value);
          downloaded += value.length;

          request.onProgress!(downloaded, r.contentLength ?? 0);
        } catch (e) {
          request.onFail!();
          sub.cancel();
          mainstream.cancel();
        }
      }, onDone: () async {
        sub.cancel();
        mainstream.cancel();
        // Save the file
        File file;
        try {
          print("${p.join(dir.path, request.fileName)}");
          file = File(p.join(dir.path, request.fileName));
          if (file.existsSync()) file.deleteSync();
          final Uint8List bytes = Uint8List(r.contentLength!);
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file.writeAsBytes(bytes);
        } catch (e) {
          print("$TAG(ERROR): ${e.toString()}");
          request.onFail!();
          return;
        }
        request.onDone!(file);
      });
    });
  }
}
