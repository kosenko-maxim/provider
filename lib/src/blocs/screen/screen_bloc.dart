import 'package:bloc/bloc.dart' show Bloc;
import 'package:meta/meta.dart' show required;
//import '../../../temp/screen_repository_test.dart';

import '../../../src/models/errors/auth_error.dart' show AuthError;
import '../../../src/models/screen/screen_model.dart' show ScreenModel;
import '../../resources/auth_repository.dart' show AuthRepository;
import '../../resources/screen_repository.dart' show ScreenRepository;
import '../auth/auth_bloc.dart' show AuthBloc;
import '../auth/auth_event.dart' show RefreshTokenFailed;
import '../generic/helpers/is_refresh_error.dart' show isRefreshError;
import 'screen_event.dart'
    show ScreenEvent, ScreenRequested, ScreenReceived, ComponentAuthError;
import 'screen_state.dart'
    show
        ScreenDataLoaded,
        ScreenDataLoadingError,
        ScreenAuthorizationError,
        ScreenLoading,
        ScreenState,
        ScreenUninitialized;

class ScreenBloc extends Bloc<ScreenEvent, ScreenState> {
  ScreenBloc(
      {@required this.authBloc,
      @required this.authRepository,
      @required this.screenRepository});

  final AuthBloc authBloc;
  final ScreenRepository screenRepository;
  final AuthRepository authRepository;

  @override
  ScreenState get initialState => ScreenUninitialized();

  @override
  Stream<ScreenState> mapEventToState(ScreenEvent event) async* {
    if (event is ScreenRequested) {
      yield* _requestScreen(event, tryToRefresh: true);
    }

    if (event is ScreenReceived) {
      yield ScreenDataLoaded(event.screen);
    }

    if (event is ComponentAuthError) {
      authBloc.dispatch(RefreshTokenFailed());
      yield ScreenAuthorizationError(event.route);
    }
  }

  Stream<ScreenState> _requestScreen(ScreenRequested event,
      {bool tryToRefresh = false}) async* {
    try {
//      if (!(currentState is ScreenLoading)) {
//        yield ScreenLoading();
//      }

      final String token = await authRepository.accessToken;
      final ScreenModel screen =
          await screenRepository.fetchScreen(query: event.route, token: token);
      yield ScreenDataLoaded(screen);
    } catch (error) {
      if (error is AuthError) {
        if (tryToRefresh) {
          final String refreshToken = await authRepository.refreshToken;
//        var refreshToken = 'c382a820-f0d2-43d8-b6e2-58c0f6d66708';
          if (refreshToken != null) {
            try {
              // refresh and try to request screen again
              await authRepository.refresh();
              yield* _requestScreen(event);
            } catch (error) {
              if (isRefreshError(error)) {
                yield* _emitAuthError(event);
              } else {
                // didn't refresh because of no connection/server error etc
                yield ScreenDataLoadingError(error.toString());
              }
            }
          } else {
            // no refresh token stored
            print('---> no refresh token stored');
            yield* _emitAuthError(event);
          }
          // tryRefresh block end

        } else {
          yield* _emitAuthError(event);
        }
      } else {
        yield ScreenDataLoadingError(error.toString());
      }
    }
  }

  Stream<ScreenState> _emitAuthError(ScreenRequested event) async* {
    print('---> emit auth error');
    authBloc.dispatch(RefreshTokenFailed());
    yield ScreenAuthorizationError(event.route);
  }
}
