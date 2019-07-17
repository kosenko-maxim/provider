class TokenResponseModel {
  TokenResponseModel(
      {String accessToken,
      String tokenType,
      int expiresIn,
      String refreshToken,
      String scope}) {
    _accessToken = accessToken;
    _tokenType = tokenType;
    _expiresIn = expiresIn;
    _refreshToken = refreshToken;
    _scope = scope;
  }

  TokenResponseModel.fromJson(Map<String, dynamic> json) {
    _accessToken = json['access_token'];
    _tokenType = json['token_type'];
    _expiresIn = json['expires_in'];
    _refreshToken = json['refresh_token'];
    _scope = json['scope'];
  }

  String _accessToken;
  String _tokenType;
  int _expiresIn;
  String _refreshToken;
  String _scope;

  String get accessToken => _accessToken;

  String get tokenType => _tokenType;

  int get expiresIn => _expiresIn;

  String get refreshToken => _refreshToken;

  String get scope => _scope;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['access_token'] = accessToken;
    json['token_type'] = tokenType;
    json['expires_in'] = expiresIn;
    json['refresh_token'] = refreshToken;
    json['scope'] = scope;
    return json;
  }
}
