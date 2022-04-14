class AuthModel {
  AuthModel(
      {required this.accessToken,
      required this.expiresIn,
      required this.refreshToken,
      required this.tokenType});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;
}
