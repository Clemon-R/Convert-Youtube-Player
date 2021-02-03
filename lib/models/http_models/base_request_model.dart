class BaseRequestModel {
  bool success = false;

  BaseRequestModel();
  fromJson(Map<String, dynamic> json) {}
  Map<String, dynamic> toJson() {
    return null;
  }
}
