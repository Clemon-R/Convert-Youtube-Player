// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_request_status_rest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckRequestStatusRestModel _$CheckRequestStatusRestModelFromJson(
    Map<String, dynamic> json) {
  return CheckRequestStatusRestModel(
    uuid: json['uuid'] as String,
    status: json['status'] as String,
    percent: json['percent'] as int?,
    title: json['title'] as String?,
    thumbnail: json['thumbnail'] as String?,
    fileUrl: json['fileUrl'] as String?,
    url: json['url'] as String?,
  );
}

Map<String, dynamic> _$CheckRequestStatusRestModelToJson(
        CheckRequestStatusRestModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'status': instance.status,
      'percent': instance.percent,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'fileUrl': instance.fileUrl,
      'url': instance.url,
    };
