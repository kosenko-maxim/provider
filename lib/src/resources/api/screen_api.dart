import 'dart:async' show Future;
import 'package:meta/meta.dart' show required;

import 'package:http/http.dart' as http;

import '../../constants/navigation.dart' show ROOT_PAGE;
import 'constants/url.dart' show GUEST_URL, USER_URL;
import 'generic/api.dart' show Api;

class ScreenApi extends Api {
  String getUrl(String token, String route) {
    final String context = route.replaceFirst('user/', '');
    if (!isTokenFormat(token) &&
        (route == ROOT_PAGE ||
            (route.substring(0, route.lastIndexOf('/')) == ROOT_PAGE))) {
      return '$GUEST_URL$context';
    }

    return '$USER_URL$context';
  }

  Future<Map<String, dynamic>> fetchScreen(
      {@required String route, String token}) async {
    try {
      print('===> screen request: ${getUrl(token, route)}');
      print('===>  makeHeaders(token): ${ makeHeaders(token)}');
      final http.Response response =
          await client.get(getUrl(token, route), headers: makeHeaders(token));

      if (response.statusCode == 200) {
        final dynamic json = await processResponse(response);
        return json;
      } else {
        throw response;
      }
    } catch (error) {
      throw await inferError(error);
    }
  }
}
