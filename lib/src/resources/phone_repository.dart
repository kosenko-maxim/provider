import 'dart:async' show Future;
import '../models/phone/phone_all_response.dart' show AllPhoneResponse;
import 'api/phone_api.dart' show PhoneApi;

class PhoneRepository {
  PhoneApi phoneApi = PhoneApi();

  Future<AllPhoneResponse> getCountriesPhoneData({int creationDate}) {
    return phoneApi.requestCountriesPhoneData(creationDate);
  }

  Future<String> getCountryByIp() {
    return phoneApi.countryLookUp();
  }
}
