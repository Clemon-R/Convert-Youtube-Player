import 'dart:io';

import 'package:youtekmusic/enums/end_point_enum.dart';
import 'package:youtekmusic/enums/urls_enum.dart';
import 'package:youtekmusic/models/rest_models/convert_mp3_rest_models/check_request_status_rest_model.dart';
import 'package:youtekmusic/models/rest_models/convert_mp3_rest_models/start_convert_music_request_model.dart';
import 'package:youtekmusic/models/rest_models/http_request_model.dart';
import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/services/base_service.dart';
import 'package:youtekmusic/services/http_service.dart';

class Mp3ConverterRepository extends BaseService {
  final _httpService = ServicesProvider.get<HttpService>();

  Future<CheckRequestStatusRestModel> startYoutubeConvertion(
      {required String url, required String extension}) async {
    var body = StartConvertMusicRestModel(url: url, extension: extension);
    var requestConfig = HttpRequestModel<StartConvertMusicRestModel,
            CheckRequestStatusRestModel>(
        fromJson: (json) => CheckRequestStatusRestModel.fromJson(json),
        domain: EndPointEnum.Mp3Convert,
        url: UrlsEnum.start.toUrlString(EndPointEnum.Mp3Convert),
        body: body);
    var response = await _httpService.post(requestConfig);
    if (response.code != HttpStatus.ok || response.content == null)
      throw Exception("Error while starting converting");
    return response.content!;
  }

  Future<CheckRequestStatusRestModel> checkYoutubeConvertion(
      {required String requestId}) async {
    var requestConfig = HttpRequestModel<CheckRequestStatusRestModel,
            CheckRequestStatusRestModel>(
        fromJson: (json) => CheckRequestStatusRestModel.fromJson(json),
        domain: EndPointEnum.Mp3Convert,
        url: UrlsEnum.check
            .toUrlString(EndPointEnum.Mp3Convert)
            .replaceAll(":id", requestId));
    var response = await _httpService.get(requestConfig);
    if (response.code != HttpStatus.ok || response.content == null)
      throw Exception("Error while starting checking status");
    return response.content!;
  }

  Future<String?> getCookiesFromCsrf() async {
    var requestConfig = HttpRequestModel(
        domain: EndPointEnum.Mp3Convert,
        url: UrlsEnum.csrf.toUrlString(EndPointEnum.Mp3Convert));
    var response = await _httpService.get(requestConfig);
    if (response.code != HttpStatus.ok)
      throw Exception("Error while getting cookies");
    return response.cookies;
  }
}
