import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convertyoutubeplayer/Services/token_service.dart';
import 'package:convertyoutubeplayer/enums/HeaderDomainEnum.dart';
import 'package:convertyoutubeplayer/requestPayloads/requestDownload.dart';
import 'package:convertyoutubeplayer/requestPayloads/requestPayload.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HttpService {
  static const String TAG = "HttpService";

  static HttpService _instance = HttpService();
  static HttpService get instance => _instance;

  Map<String, String> headerSelector(HeaderDomainEnum type) {
    Map<String, String> result;
    switch (type) {
      case HeaderDomainEnum.Mp3Convert:
        result = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Token': TokenService.instance.token,
          'X-XSFR-Token': TokenService.instance.xsrfToken
        };
        break;
      case HeaderDomainEnum.Youtube:
        break;
    }
    return result;
  }

  Future<T> post<U, T>(RequestPayload<U, T> request) async {
    var json = jsonEncode(request.body);

    print("$TAG: Post Url(${request.url}), Body($json)");
    var requestResult = await http.post(request.url,
        headers: headerSelector(request.domain),
        body: json,
        encoding: Encoding.getByName("utf-8"));
    var body = requestResult.body;

    if (requestResult.statusCode == 200)
      return request.onSuccess(jsonDecode(body));
    else
      return request.onFail(jsonDecode(body));
  }

  Future<dynamic> get(RequestPayload request) async {
    print("$TAG: Get Url(${request.url})");
    var requestResult =
        await http.get(request.url, headers: headerSelector(request.domain));
    var body = requestResult.body;
    if (requestResult.statusCode == 200)
      return request.onSuccess(jsonDecode(body));
    else
      return request.onFail(jsonDecode(body));
  }

  Future<void> downloadFile(RequestDownload request) async {
    var httpClient = http.Client();
    var result = http.Request('GET', Uri.parse(request.url));
    Future<StreamedResponse> response;
    try{
      response = httpClient.send(result);
    } catch(e){
      request.onFail();
      return;
    }
    var dir =
        Directory(p.join((await getApplicationDocumentsDirectory())
            .path, "musics"));
    if (!await dir.exists())
      dir.create(recursive: true);

    var chunks = new List<List<int>>();
    var downloaded = 0;
    dynamic mainstream;
    mainstream = response.asStream().listen((http.StreamedResponse r) {
      dynamic sub;
      sub = r.stream.listen((value) {
        try{
          chunks.add(value);
          downloaded += value.length;

          request.onProgress(downloaded, r.contentLength);
        } catch (e){
          request.onFail();
          sub.cancel();
          mainstream.cancel();
        }
      }, onDone: () async {
        sub.cancel();
        mainstream.cancel();
        // Save the file
        try {
          print("${p.join(dir.path, request.fileName)}");
          var file = new File(p.join(dir.path, request.fileName));
          final Uint8List bytes = Uint8List(r.contentLength);
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file.writeAsBytes(bytes);
          request.onDone(file);
        } catch (e){
          request.onFail();
        }
      });
    });
  }
}
