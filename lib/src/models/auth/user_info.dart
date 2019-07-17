import 'phone_model.dart';

class UserInfo {
  UserInfo({this.preferredUsername, this.phone});

  UserInfo.fromJson(Map<String, dynamic> json) {
    preferredUsername = json['preferred_username'];
    phone = json['phone'] != null ? PhoneModel.fromJson(json['phone']) : null;
  }

  String preferredUsername;
  PhoneModel phone;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['preferred_username'] = preferredUsername;
    if (phone != null) {
      data['phone'] = phone.toJson();
    }
    return data;
  }
}
