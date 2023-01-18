import '../../setup.dart';

class AppHeader {
  String? accessToken;
  String? lat;
  String? long;

  AppHeader({this.accessToken});

  AppHeader.fromJson(Map<String, dynamic> json) {
    accessToken = json['Authorization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Content-Type'] = 'application/json';
    data['Connection'] = 'keep-alive';
    if ((accessToken ?? '').isNotEmpty) {
      data['Authorization'] = 'Bearer $accessToken';
    }

    return data;
  }
}

