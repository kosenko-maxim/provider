import 'package:bloc/bloc.dart';
import '../../models/phone/country_phone_data.dart';
import '../../models/phone/phone_all_response.dart';
import '../../resources/phone_repository.dart';

import 'phone_event.dart';
import 'phone_state.dart';

class PhoneBloc extends Bloc<PhoneEvent, PhoneState> {
  PhoneBloc(this.repository);

  PhoneRepository repository;

  @override
  PhoneState get initialState => PhoneUninitialized();

  @override
  Stream<PhoneState> mapEventToState(PhoneEvent event) async* {
    if (event is PhoneCountriesDataRequested) {
      List<CountryPhoneData> countryPhoneDataList;
      List<CountryPhoneData> topCountryPhoneDataList;
      int creationDate;
      CountryPhoneData countryPhoneData;
      yield PhoneLoading();
      try {
        final List<dynamic> waitList = await Future.wait(<Future<dynamic>>[
          repository.getCountriesPhoneData(
              creationDate: getCreationDate(currentState)),
          repository.getCountryByIp(),
        ]);

        final AllPhoneResponse allPhoneResponse = waitList[0];
        final String countryIdByIp = waitList[1];
        if (allPhoneResponse != null) {
          countryPhoneDataList = allPhoneResponse.countryPhonesData;
          topCountryPhoneDataList = allPhoneResponse.topCountryPhonesData;
          creationDate = allPhoneResponse.creationDate;
          countryPhoneData = getCountryPhone(
              countryPhoneDataList, topCountryPhoneDataList, countryIdByIp);
        } else {
          countryPhoneData = getCountryPhoneDataByState(currentState);
          countryPhoneDataList = getListCountryPhoneDataByState(currentState);
          topCountryPhoneDataList =
              getListTopCountryPhoneDataByState(currentState);
          creationDate = getCreationDate(currentState);
        }

        yield PhoneCountriesDataLoaded(countryPhoneDataList,
            topCountryPhoneDataList, creationDate, countryPhoneData);
      } catch (error) {
        print('=> phone bloc error => $error');
        yield PhoneLoadingError(error: error.toString());
      }
    }
  }

  CountryPhoneData getCountryPhone(List<CountryPhoneData> countryPhoneDataList,
      List<CountryPhoneData> topCountryPhoneDataList, String countryIdByIp) {
    final CountryPhoneData countryPhoneByIp =
        getCountryPhoneDataByIp(countryPhoneDataList, countryIdByIp);
    return countryPhoneByIp != null
        ? countryPhoneByIp
        : getCountryPhoneDataByIp(topCountryPhoneDataList, countryIdByIp);
  }

  int getCreationDate(PhoneState currentState) {
    if (currentState is PhoneCountriesDataLoaded)
      return currentState.creationDate;
    else
      return null;
  }

  CountryPhoneData getCountryPhoneDataByState(PhoneState currentState) {
    if (currentState is PhoneCountriesDataLoaded)
      return currentState.countryPhoneByIp;
    else
      return null;
  }

  List<CountryPhoneData> getListCountryPhoneDataByState(
      PhoneState currentState) {
    if (currentState is PhoneCountriesDataLoaded)
      return currentState.countryData;
    else
      return null;
  }

  List<CountryPhoneData> getListTopCountryPhoneDataByState(
      PhoneState currentState) {
    if (currentState is PhoneCountriesDataLoaded)
      return currentState.topCountryData;
    else
      return null;
  }

  CountryPhoneData getCountryPhoneDataByIp(
      List<CountryPhoneData> list, String countryIdByIp) {
    final int index =
    list.indexWhere((CountryPhoneData it) =>
    it.countryId == countryIdByIp);
    return index != -1 ? list[index] : null;
  }
}
