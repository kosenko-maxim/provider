import 'package:meta/meta.dart' show required;
import 'package:bloc/bloc.dart' show Bloc;

import '../../resources/auth_repository.dart' show AuthRepository;
import '../auth/auth_bloc.dart' show AuthBloc;
import '../auth/auth_event.dart' show UserLoggedOut;

import 'logout_event.dart' show LogoutButtonTapped, LogOutEvent;
import 'logout_state.dart'
    show LogOutSending, LogOutError, LogOutNotActive, LogOutState;

class LogOutBloc extends Bloc<LogOutEvent, LogOutState> {
  LogOutBloc(
      {@required AuthBloc authBloc, @required AuthRepository authRepository})
      : assert(authBloc != null),
        assert(authRepository != null),
        _authBloc = authBloc,
        _authRepository = authRepository;

  final AuthBloc _authBloc;
  final AuthRepository _authRepository;

  @override
  LogOutState get initialState => LogOutNotActive();

  @override
  Stream<LogOutState> mapEventToState(LogOutEvent event) async* {
    if (event is LogoutButtonTapped) {
      yield* _mapLogOutRequestedToState(event);
    }
  }

  Stream<LogOutState> _mapLogOutRequestedToState(
      LogoutButtonTapped event) async* {
    try {
      yield LogOutSending();
      await _authRepository.logout();
      await _authRepository.clearAll();
      _authBloc.dispatch(UserLoggedOut());
      yield LogOutNotActive();
    } catch (error) {
      yield LogOutError(error.toString());
    }
  }
}
