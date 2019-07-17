import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocListener, BlocListenerTree;

import '../../../../src/utils/route_transition.dart' show SlideRoute;
import '../../../../temp/resources/phone_repository_test.dart'
    show TestPhoneRepository;
import '../../../blocs/auth/auth_bloc.dart' show AuthBloc;
import '../../../blocs/login/login_bloc.dart' show LoginBloc;
import '../../../blocs/login/login_event.dart' show LoginEvent, OtpRequested;
import '../../../blocs/login/login_state.dart'
    show LoginState, IsFetchingOtp, OtpSent, PhoneError;
import '../../../blocs/phone/phone_bloc.dart' show PhoneBloc;
import '../../../blocs/phone/phone_event.dart'
    show PhoneEvent, PhoneCountriesDataRequested;
import '../../../blocs/phone/phone_state.dart'
    show
        PhoneCountriesDataLoaded,
        PhoneLoading,
        PhoneLoadingError,
        PhoneState,
        PhoneUninitialized;
import '../../../models/phone/country_phone_data.dart' show CountryPhoneData;
import '../../../resources/auth_repository.dart' show AuthRepository;
import '../../../resources/phone_repository.dart' show PhoneRepository;
import '../../../utils/show_alert.dart' show showError;
import '../../components/page_template.dart' show PageTemplate;
import '../../components/pickers/phone/phone_picker.dart' show PhonePicker;
import '../../components/styled/styled_button.dart' show StyledButton;
import '../../components/styled/styled_circular_progress.dart'
    show StyledCircularProgress;

import 'otp.dart' show OtpScreen;

class PhoneScreen extends StatefulWidget {
  factory PhoneScreen({AuthBloc authBloc, Map<String, dynamic> arguments}) {
    final String returnTo = arguments != null ? arguments['returnTo'] : null;
    return PhoneScreen._(authBloc: authBloc, returnTo: returnTo);
  }

  const PhoneScreen._({@required this.authBloc, this.returnTo});

  final AuthBloc authBloc;
  final String returnTo;

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  CountryPhoneData selectedItem;
  bool isAgree = true;
  bool validPhone = false;
  LoginBloc _loginBloc;
  PhoneBloc _phoneBloc;
  TextEditingController phoneController = TextEditingController();
  String phoneNumber;

  void _phoneListener() {
    setState(() {
      validPhone = _isValid();
    });
  }

  bool _isValid() {
    return phoneController.text.isNotEmpty &&
        selectedItem != null &&
        _validLength(selectedItem.lengths, phoneController.text.length) &&
        hasMatch(phoneController.text, selectedItem.numberPattern);
  }

  bool _validLength(List<int> lengthList, int length) {
    return lengthList.firstWhere((int item) => item == length,
                orElse: () => 0) >
            0
        ? true
        : false;
  }

  bool hasMatch(String value, String reg) {
    final RegExp regExp = RegExp(reg);
    return regExp.hasMatch(value);
  }

  @override
  void initState() {
    super.initState();
//    _phoneBloc = PhoneBloc(TestPhoneRepository());
    _phoneBloc = PhoneBloc(PhoneRepository());
    init();
    _loginBloc = LoginBloc(widget.authBloc, AuthRepository());
    phoneController.addListener(_phoneListener);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        goBack: () {
          Navigator.of(context)
              .pushReplacementNamed(Navigator.defaultRouteName);
        },
        title: 'Log in',
        body: Container(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0),
            margin: const EdgeInsets.only(bottom: 12.0),
            child: BlocListenerTree(
                blocListeners: <BlocListener<dynamic, dynamic>>[
                  BlocListener<LoginEvent, LoginState>(
                      bloc: _loginBloc,
                      listener: (BuildContext context, LoginState state) {
                        print('===> state listener name  ${state.runtimeType}');
                        if (state is OtpSent) {
                          Navigator.push(
                              context,
                              SlideRoute(
                                  widget: OtpScreen(
                                    authBloc: widget.authBloc,
                                    loginBloc: _loginBloc,
                                    phoneBloc: _phoneBloc,
                                    selectedItem: selectedItem,
                                    phoneNumber: phoneNumber,
                                    returnTo: widget.returnTo,
                                  ),
                                  side: 'left'));
                        }
                        if (state is PhoneError) {
                          showError(context, state);
                        }
                      }),
                  BlocListener<PhoneEvent, PhoneState>(
                    bloc: _phoneBloc,
                    listener: (BuildContext context, PhoneState state) {
                      if (state is PhoneLoadingError) {
                        showError(context, state);
                      }
                    },
                  )
                ],
                child: BlocBuilder<PhoneEvent, PhoneState>(
                    bloc: _phoneBloc,
                    builder: (BuildContext context, PhoneState state) {
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: Stack(
                          children: <Widget>[
                            ListView(
                              children: <Widget>[
                                _buildTittle(),
                                if (state is PhoneUninitialized ||
                                    state is PhoneLoading)
                                  Padding(
                                    child: StyledCircularProgress(
                                        size: 'sm',
                                        color: Theme.of(context).primaryColor),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                if (state is PhoneCountriesDataLoaded)
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: _buildPhonePicker(state),
                                  ),
                                if (state is PhoneLoadingError)
                                  Text(state.toString(),
                                      style: const TextStyle(fontSize: 16.0)),
                                Container(
                                  margin: const EdgeInsets.only(left: 8.0),
                                  child: _buildTerms(),
                                ),
                              ],
                            ),
                            _buildSubmit(loginBloc: _loginBloc)
                          ],
                        ),
                      );
                    }))));
  }

  Future<void> _refresh() async {
    init();
  }

  void init() {
    _phoneBloc.dispatch(PhoneCountriesDataRequested());
  }

  Widget _buildTittle() {
    return Container(
        alignment: const Alignment(-1, 0),
        margin: const EdgeInsets.only(top: 56.0, bottom: 16.0, left: 24.0),
        child: const Text('Enter your phone number',
            style: TextStyle(fontSize: 16)));
  }

  Widget _buildTerms() {
    return Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: Row(children: <Widget>[
          Checkbox(
            activeColor: Theme.of(context).primaryColor,
            value: isAgree,
            onChanged: (bool value) {
              setState(() {
                isAgree = !isAgree;
              });
            },
          ),
          Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text('I accept the',
                            style: TextStyle(
                                fontSize: 16.0, color: Color(0xde000000))),
                        Text(' Term and conditions,',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor))
                      ],
                    ),
                    Text('Privacy policy',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor)),
                  ])),
        ]));
  }

  Widget _buildPhonePicker(PhoneCountriesDataLoaded state) {
    return PhonePicker(
        onSelected:
            (bool value, CountryPhoneData countryPhone, String inputtedPhone) {
          setState(() {
            selectedItem = countryPhone;
            validPhone = _isValid();
            phoneNumber = inputtedPhone;
          });
        },
        selectedItem: selectedItem,
        phoneController: phoneController,
        countryPhoneDataList: state.countryData,
        favorites: state.topCountryData,
        itemByIp: state.countryPhoneByIp,
        isValid: _isValid);
  }

  Widget _buildSubmit({@required LoginBloc loginBloc}) {
    return BlocBuilder<LoginEvent, LoginState>(
        bloc: loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Align(
            alignment: FractionalOffset.bottomCenter,
            child: StyledButton(
              loading: state is IsFetchingOtp,
              onPressed: isAgree && validPhone
                  ? () {
                      _loginBloc.dispatch(OtpRequested(
                          phoneCountryId: selectedItem.countryId,
                          phoneNumber: '+${selectedItem.code}${phoneNumber}'));
                    }
                  : null,
              text: 'SUBMIT',
            ),
          );
        });
  }
}
