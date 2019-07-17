import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:meta/meta.dart' show required;

import 'package:http/http.dart' as http;

import '../../../models/auth/token_response_model.dart' show TokenResponseModel;
import '../../../models/auth/user_info.dart' show UserInfo;
import '../generic/api.dart' show Api;
import 'constants/url.dart' show OAUTH_URL, USER_URL;

class AuthApi extends Api {
  static const String _contentType = 'application/x-www-form-urlencoded';
  static const String clientId = 'user-mobile';

  // endpoints
  static const String _otpEndpoint = '${OAUTH_URL}otp';
  static const String _tokenEndpoint = '${OAUTH_URL}token';
  static const String _logoutEndpoint = '${OAUTH_URL}logout';
  static const String _userInfoEndpoint = '${USER_URL}userinfo';

  static String _encodeMapToUrl(Map<String, dynamic> parameters) {
    final List<String> urlEncodedForm = <String>[];
    parameters.forEach((String key, dynamic value) => value != null
        ? urlEncodedForm.add(
            '${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value.toString())}')
        : null);

    return urlEncodedForm.join('&');
  }

  Map<String, String> _makeHeaders({String accessToken}) {
    final Map<String, String> headers = <String, String>{
      'Content-type': _contentType,
    };

    if (accessToken is String && accessToken.isNotEmpty) {
      headers['$authHeaderKey'] = formToken(accessToken);
    }

    return headers;
  }

  Future<void> requestOtp(
      {@required String codeChallenge,
      @required String appId,
      @required String phoneCountryId,
      @required String phoneNumber}) async {
    try {
      final http.Response response = await client.post(
        _otpEndpoint,
        headers: _makeHeaders(),
        body: _encodeMapToUrl(<String, dynamic>{
          'code_challenge': codeChallenge,
          'app_id': appId,
          'phone_country_id': phoneCountryId,
          'phone_number': phoneNumber,
        }),
      );

      if (response.statusCode != 204) {
        throw response;
      }
    } catch (error) {
      throw await inferError(error);
    }
  }

  Future<TokenResponseModel> requestToken(
      {@required String phoneNumber,
      @required String otp,
      @required String codeVerifier,
      @required String appId,
      @required String phoneCountryId}) async {
    try {
      final http.Response response = await client.post(
        _tokenEndpoint,
        headers: _makeHeaders(),
        body: _encodeMapToUrl(<String, dynamic>{
          'grant_type': 'otp',
          'client_id': clientId,
          'phone_number': phoneNumber,
          'otp': otp,
          'code_verifier': codeVerifier,
          'app_id': appId,
          'phone_country_id': phoneCountryId,
        }),
      );

      if (response.statusCode != 200) {
        throw response;
      }

      return TokenResponseModel.fromJson(json.decode(response.body));
    } catch (error) {
      throw await inferError(error);
    }
  }

  Future<TokenResponseModel> refreshToken(
      {@required String refreshToken}) async {
    try {
      final http.Response response = await client.post(
        _tokenEndpoint,
        headers: _makeHeaders(),
        body: _encodeMapToUrl(<String, dynamic>{
          'grant_type': 'refresh_token',
          'client_id': clientId,
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode != 200) {
        throw response;
      }

      return TokenResponseModel.fromJson(json.decode(response.body));
    } catch (error) {
      throw await inferError(error);
    }
  }

  Future<void> logout({String accessToken}) async {
    try {
      final http.Response response = await client.post(_logoutEndpoint,
          headers: _makeHeaders(),
          body: _encodeMapToUrl(<String, dynamic>{'accessToken': accessToken}));

      if (response.statusCode != 204) {
        throw response;
      }
    } catch (error) {
      throw await inferError(error);
    }
  }

  Future<UserInfo> loadUserProfile({@required String accessToken}) async {
    try {
      final http.Response response = await client.get(
        _userInfoEndpoint,
        headers: _makeHeaders(accessToken: accessToken),
      );

      if (response.statusCode != 200) {
        throw response;
      }

      return UserInfo.fromJson(json.decode(response.body));
    } catch (error) {
      throw await inferError(error);
    }
  }
}
