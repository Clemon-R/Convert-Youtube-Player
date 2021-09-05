import 'package:json_annotation/json_annotation.dart';
import 'package:youtekmusic/models/rest_models/irest_model.dart';

part 'check_request_status_rest_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckRequestStatusRestModel extends IRestModel {
  String uuid;
  String status;
  int? percent;
  String? title;
  String? thumbnail;
  String? fileUrl;
  String? url;

  CheckRequestStatusRestModel(
      {required this.uuid,
      required this.status,
      required this.percent,
      required this.title,
      required this.thumbnail,
      required this.fileUrl,
      required this.url});

  factory CheckRequestStatusRestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckRequestStatusRestModelFromJson(json["data"]);
  Map<String, dynamic> toJson() => _$CheckRequestStatusRestModelToJson(this);
}
