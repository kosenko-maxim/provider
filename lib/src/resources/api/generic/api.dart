import 'dart:async' show Completer, Future;
import 'dart:convert' show json, utf8;
import 'dart:io' show SocketException;
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;

import '../../../models/errors/auth_error.dart' show AuthError;
import '../../../models/errors/connection_error.dart' show ConnectionError;
import '../../../models/errors/http_error.dart' show HttpError;
import '../../../models/errors/no_internet_error.dart' show NoInternetError;

class Api {
  final http.Client _client = http.Client();

  http.Client get client => _client;

  final String authHeaderKey = 'Authorization';

  bool isTokenFormat(String token) => token is String && token.isNotEmpty;

  String formToken(String token) => 'Bearer $token';

  Map<String, String> makeHeaders(String token) => isTokenFormat(token)
      ? <String, String>{'$authHeaderKey': formToken(token)}
      : null;

  Future<dynamic> processResponse(http.BaseResponse response) async {
    print('===> response.statusCode: ${response.statusCode}');
    if (response is http.Response) {
      print('===> response.body: ${response.body}');
    }

    if (response is http.Response) {
      return json.decode(response.body);
    } else if (response is http.StreamedResponse) {
      final Completer<Object> completer = Completer<Object>();
      response.stream.transform(utf8.decoder).listen((Object value) {
        completer.complete(value);
      });
      final String result = await completer.future;
      return json.decode(result);
    }
  }

  Future<dynamic> inferError(dynamic object) async {
    if (object is SocketException) {
      final bool internet = await _checkInternet();
      if (internet) {
        return ConnectionError();
      } else {
        return NoInternetError();
      }
    }

    if (object is http.BaseResponse) {
      final int statusCode = object.statusCode;
      final Map<String, dynamic> parsedResponse = await processResponse(object);
      final String description = parsedResponse['error_description'];
      final String message =
          description is String ? description : parsedResponse['message'];

      if (statusCode == 401) {
        return AuthError(message: message, statusCode: statusCode);
      }

      return HttpError(message: message, statusCode: statusCode);
    }

    return object;
  }

  Future<bool> _checkInternet() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
