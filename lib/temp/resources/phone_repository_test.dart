import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:user_mobile/src/models/phone/phone_all_response.dart';
import '../../src/resources/phone_repository.dart';

class TestPhoneRepository extends PhoneRepository {
  final String uRl = 'lib/assets/country_phone_data.json';

  @override
  Future<AllPhoneResponse> getCountriesPhoneData({int creationDate}) async {
    final String response = await rootBundle.loadString(uRl);
    return AllPhoneResponse.fromJson(json.decode(response));
  }
}
