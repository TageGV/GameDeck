class Authentication {
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;
  int? tokenExpireTime;
  int? refreshTokenExpireTime;
  String? locale;
  String? secret;

  Authentication.fromJson(Map<String, dynamic> json) {
    tokenType = json["token_type"];
    expiresIn = json["expires_in"];
    accessToken = json["access_token"];
    refreshToken = json["refresh_token"];
    tokenExpireTime = json["token_expire_time"];
    refreshTokenExpireTime = json["refresh_token_expire_time"];
    locale = json["locale"];
    secret = json["secret"];
  }

}