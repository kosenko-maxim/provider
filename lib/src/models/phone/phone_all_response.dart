
import 'country_phone_data.dart';

class AllPhoneResponse {
  AllPhoneResponse(
      {this.creationDate, this.topCountryPhonesData, this.countryPhonesData});

  AllPhoneResponse.fromJson(Map<String, dynamic> json) {
    creationDate = json['creationDate']!=null?json['creationDate']:null;
    if (json['topCountryPhonesData'] != null) {
      topCountryPhonesData = <CountryPhoneData>[];
      json['topCountryPhonesData'].forEach((dynamic v) {
        topCountryPhonesData.add(CountryPhoneData.fromJson(v));
      });
    }
    if (json['countryPhonesData'] != null) {
      countryPhonesData = <CountryPhoneData>[];
      json['countryPhonesData'].forEach((dynamic v) {
        countryPhonesData.add(CountryPhoneData.fromJson(v));
      });
    }
  }

  int creationDate;
  List<CountryPhoneData> topCountryPhonesData;
  List<CountryPhoneData> countryPhonesData;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['creationDate'] = creationDate;
    if (topCountryPhonesData != null) {
      data['topCountryPhonesData'] =
          topCountryPhonesData.map((dynamic v) => v.toJson()).toList();
    }
    if (countryPhonesData != null) {
      data['countryPhonesData'] =
          countryPhonesData.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}


