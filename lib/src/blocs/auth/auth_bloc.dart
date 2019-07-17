import 'dart:async' show Stream;

import 'package:meta/meta.dart' show required;
import 'package:bloc/bloc.dart' show Bloc;

import '../../models/auth/user_info.dart' show UserInfo;
import '../../resources/auth_repository.dart' show AuthRepository;

import 'auth_event.dart'
    show
        AppStarted,
        AuthEvent,
        UserLoggedIn,
        RefreshTokenFailed,
        UserLoggedOut;
import 'auth_state.dart'
    show AuthState, AuthUnauthorized, AuthAuthorized;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({@required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  AuthState get initialState => AuthUnauthorized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState();
    } else if (event is RefreshTokenFailed) {
      yield* _unauthorize();
    } else if (event is UserLoggedOut) {
      yield* _unauthorize();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    await _authRepository.setAppId();

    final String refreshToken = await _authRepository.refreshToken;
    if (refreshToken is String && refreshToken.isNotEmpty) {
      final UserInfo userProfile = await _authRepository.userProfile;
      yield AuthAuthorized(userProfile);
    } else {
      // no token stored
      yield AuthUnauthorized();
    }
  }

  Stream<AuthState> _mapUserLoggedInToState() async* {
    try {
      final UserInfo userProfile = await _authRepository.loadUserProfile();
      yield AuthAuthorized(userProfile);
    } catch (error) {
      // set authorized state anyway
      yield AuthAuthorized();
    }
  }

  Stream<AuthState> _unauthorize() async* {
    await _authRepository.clearAll();
    yield AuthUnauthorized();
  }
}
