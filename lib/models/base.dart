
class ResModel<T> {
  bool? success;
  String? dataVersion;
  T? data;
  Error? error;

  ResModel({this.success, this.dataVersion, this.data, this.error});

  ResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dataVersion = json['dataVersion'];
    data = json['data'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
}

class Error {
  String? key;
  String? content;
  Error({this.key, this.content});

  Error.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? "";
    content = json['content'] ?? "";
  }
}