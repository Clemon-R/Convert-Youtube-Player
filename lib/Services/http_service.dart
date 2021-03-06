import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convertyoutubeplayer/services/token_service.dart';
import 'package:convertyoutubeplayer/enums/header_domain_enum.dart';
import 'package:convertyoutubeplayer/models/http_models/base_request_model.dart';
import 'package:convertyoutubeplayer/models/http_models/download_request_model.dart';
import 'package:convertyoutubeplayer/models/http_models/request_model.dart';
import 'package:convertyoutubeplayer/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HttpService extends BaseService {
  static const String TAG = "HttpService";

  TokenService _tokenService;

  HttpService(this._tokenService);

  Map<String, String> headerSelector(HeaderDomainEnum type) {
    Map<String, String> result;
    switch (type) {
      case HeaderDomainEnum.Mp3Convert:
        result = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Token': _tokenService.token,
          'X-XSFR-Token': _tokenService.xsrfToken
        };
        break;
      case HeaderDomainEnum.Youtube:
        break;
    }
    return result;
  }

  Future<T> post<U, T extends BaseRequestModel>(
      RequestModel<U, T> request) async {
    var json = jsonEncode(request.body);

    print("$TAG: Post Url(${request.url}), Body($json)");
    var requestResult = await http.post(request.url,
        headers: headerSelector(request.domain),
        body: json,
        encoding: Encoding.getByName("utf-8"));
    var body = requestResult.body;
    return request.onDone(body, requestResult.statusCode == 200);
  }

  Future<dynamic> get(RequestModel request) async {
    print("$TAG: Get Url(${request.url})");
    var requestResult =
        await http.get(request.url, headers: headerSelector(request.domain));
    var body = requestResult.body;
    return request.onDone(body, requestResult.statusCode == 200);
  }

  Future<void> downloadFile(DownloadRequestModel request) async {
    print("$TAG: Download Url(${request.url}), FileName(${request.fileName})");
    var httpClient = http.Client();
    var result = http.Request('GET', Uri.parse(request.url));
    Future<StreamedResponse> response;
    try {
      response = httpClient.send(result);
    } catch (e) {
      request.onFail();
      return;
    }
    var dir = Directory(
        p.join((await getApplicationDocumentsDirectory()).path, "musics"));
    if (!await dir.exists()) dir.create(recursive: true);

    var chunks = <List<int>>[];
    var downloaded = 0;
    dynamic mainstream;
    mainstream = response.asStream().listen((http.StreamedResponse r) {
      dynamic sub;
      sub = r.stream.listen((value) {
        try {
          chunks.add(value);
          downloaded += value.length;

          request.onProgress(downloaded, r.contentLength);
        } catch (e) {
          request.onFail();
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
          final Uint8List bytes = Uint8List(r.contentLength);
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file.writeAsBytes(bytes);
        } catch (e) {
          print("$TAG(ERROR): ${e.toString()}");
          request.onFail();
          return;
        }
        request.onDone(file);
      });
    });
  }
}
