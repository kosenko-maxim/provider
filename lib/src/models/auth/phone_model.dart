class PhoneModel {
  PhoneModel({this.countryId, this.number});

  PhoneModel.fromJson(Map<String, dynamic> json) {
    countryId = json['countryId'];
    number = json['number'];
  }

  String countryId;
  String number;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryId'] = countryId;
    data['number'] = number;
    return data;
  }
}
