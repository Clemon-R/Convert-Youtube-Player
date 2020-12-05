class CheckConvertPayloadRequest {
  String uuid;
  String status;

  CheckConvertPayloadRequest({this.uuid, this.status});

  CheckConvertPayloadRequest.fromJson(Map<String, dynamic> json)
      : uuid = json['data']['uuid'],
        status = json['data']['status'];
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'status': status,
      };
}
