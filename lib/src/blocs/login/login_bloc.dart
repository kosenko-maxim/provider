import 'package:bloc/bloc.dart' show Bloc;
import 'package:user_mobile/src/blocs/auth/auth_bloc.dart' show AuthBloc;
import 'package:user_mobile/src/resources/auth_repository.dart'
    show AuthRepository;

import '../auth/auth_event.dart' show UserLoggedIn;
import 'login_event.dart'
    show CodeEnteringCanceled, LoginEvent, OtpRequested, SubmitCodeTapped;
import 'login_state.dart'
    show
    CodeError,
    IsFetchingCode,
    IsFetchingOtp,
    LoginState,
    OtpSent,
    PhoneEntering,
    PhoneError;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(AuthBloc authBloc, AuthRepository authRepository)
      : assert(authBloc != null),
        assert(authRepository != null),
        _authBloc = authBloc,
        _authRepository = authRepository;

  final AuthBloc _authBloc;
  final AuthRepository _authRepository;

  @override
  LoginState get initialState => PhoneEntering();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is OtpRequested) {
      yield* _mapOtpRequestedToState(event);
    } else if (event is CodeEnteringCanceled) {
      yield PhoneEntering();
    } else if (event is SubmitCodeTapped) {
      yield* _mapSubmitCodeTappedToState(event);
    }
  }

  Stream<LoginState> _mapOtpRequestedToState(OtpRequested event) async* {
    try {
      yield IsFetchingOtp();
      await _authRepository.getOtp(
          phoneCountryId: event.phoneCountryId,
          phoneNumber: event.phoneNumber);
      yield OtpSent();
    } catch (error) {
      yield PhoneError(error.toString());
    }
  }

  Stream<LoginState> _mapSubmitCodeTappedToState(
      SubmitCodeTapped event) async* {
    try {
      yield IsFetchingCode();
      await _authRepository.login(
          phoneNumber: event.phoneNumber,
          otp: event.otp,
          phoneCountryId: event.phoneCountryId);
      _authBloc.dispatch(UserLoggedIn());
    } catch (error) {
      yield CodeError(error.toString());
    }
  }
}
