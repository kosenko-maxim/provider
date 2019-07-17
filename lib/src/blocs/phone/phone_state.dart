import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;
import '../../models/phone/country_phone_data.dart';
@immutable
abstract class PhoneState extends Equatable {
  PhoneState([List<dynamic> props = const <dynamic>[]]) : super(props);

  @override
  String toString();
}

class PhoneUninitialized extends PhoneState {
  @override
  String toString() => 'PhoneUninitialized';
}

class PhoneLoading extends PhoneState {
  @override
  String toString() => 'PhoneLoading';
}

class PhoneCountriesDataLoaded extends PhoneState {
  PhoneCountriesDataLoaded(
      this.countryData, this.topCountryData, this.creationDate,this.countryPhoneByIp);

  final List<CountryPhoneData> countryData;
  final List<CountryPhoneData> topCountryData;
  final int creationDate;
  final CountryPhoneData countryPhoneByIp;

  @override
  String toString() => 'PhoneCountriesDataLoaded';
}

class PhoneLoadingError extends PhoneState {
  PhoneLoadingError({this.error});

  final String error;

  @override
  String toString() => error;
}
