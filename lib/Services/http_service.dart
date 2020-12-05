import 'dart:convert';

import 'package:convertyoutubeplayer/Services/token_service.dart';
import 'package:convertyoutubeplayer/requestPayloads/convertMp3/requestPayload.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const String TAG = "HttpService";

  static HttpService _instance = HttpService();
  static HttpService get instance => _instance;

  Future<T> post<U, T>(RequestPayload<U, T> request) async {
    var json = jsonEncode(request.body);
    var mp3Headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Token': TokenService.instance.token,
      'X-XSFR-Token': TokenService.instance.xsrfToken
    };

    var requestResult = await http.post(request.url,
        headers: mp3Headers, body: json, encoding: Encoding.getByName("utf-8"));
    var body = requestResult.body;
    return request.onSuccess(jsonDecode(body));
  }

  /*Future<dynamic> get(RequestPayload request) async {
    var requestResult = await http.get(request.url, headers: this._mp3Headers);
    var body = requestResult.body;
    return request.onSuccess(jsonDecode(body));
  }*/
}
