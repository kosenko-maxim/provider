import 'dart:async' show Future;
import 'package:http/http.dart' as http;

import '../../models/phone/location.dart' show Location;
import '../../models/phone/phone_all_response.dart' show AllPhoneResponse;
import './constants/url.dart' show BASE_URL;
import 'generic/api.dart' show Api;

class PhoneApi extends Api {
  Future<AllPhoneResponse> requestCountriesPhoneData(int creationDate) async {
    try {
      final String creationDateResponse =
          creationDate != null ? '?creationDate=$creationDate' : '';
      final http.Response response = await client
          .get('${BASE_URL}auth/country-phones-data$creationDateResponse');
      if (response.statusCode == 200) {
        return AllPhoneResponse.fromJson(await processResponse(response));
      } else if (response.statusCode == 204) {
        // do nothing
      } else {
        throw response;
      }
    } catch (error) {
      throw await inferError(error);
    }
  }

  Future<String> countryLookUp() async {
    try {
      final http.Response response = await http.get('http://ip-api.com/json');
      if (response.statusCode == 200) {
        return Location.fromJson(await processResponse(response)).countryCode;
      } else {
        throw response;
      }
    } catch (error) {
      throw await inferError(error);
    }
  }
}
