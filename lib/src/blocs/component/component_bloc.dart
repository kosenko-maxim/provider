import 'package:bloc/bloc.dart' show Bloc;
import 'package:meta/meta.dart' show required;

import '../../models/errors/auth_error.dart' show AuthError;
import '../../models/screen/screen_model.dart' show ScreenModel;
import '../../resources/auth_repository.dart' show AuthRepository;
import '../../resources/component_repository.dart' show ComponentRepository;
import '../generic/helpers/is_refresh_error.dart' show isRefreshError;
import '../screen/screen_bloc.dart' show ScreenBloc;
import '../screen/screen_event.dart' show ScreenReceived, ComponentAuthError;
import 'component_event.dart'
    show
        ComponentEvent,
        SendingComponentValueRequested,
        FileUploadingStart,
        FileUploadingCanceled;
import 'component_state.dart'
    show
        ComponentState,
        ComponentNotFetching,
        ComponentIsFetching,
        ComponentFetchingSuccess,
        ComponentFetchingError;

class ComponentBloc extends Bloc<ComponentEvent, ComponentState> {
  ComponentBloc(
      {@required this.screenBloc,
      @required this.authRepository,
      @required this.componentRepository});

  final ScreenBloc screenBloc;
  final AuthRepository authRepository;
  final ComponentRepository componentRepository;

  @override
  ComponentState get initialState => ComponentNotFetching();

  @override
  Stream<ComponentState> mapEventToState(dynamic event) async* {
    if (event is SendingComponentValueRequested) {
      yield* _sendItemValue(event, tryToRefresh: true);
    }

    if (event is FileUploadingStart) {
      yield ComponentIsFetching();
    }

    if (event is FileUploadingCanceled) {
      yield ComponentNotFetching();
    }
  }

  Stream<ComponentState> _sendItemValue(SendingComponentValueRequested event,
      {bool tryToRefresh = false}) async* {
    try {
      if (!(currentState is ComponentIsFetching)) {
        yield ComponentIsFetching();
      }

      final String token = await authRepository.accessToken;
      final ScreenModel screen = await componentRepository.sendItemValue(
          event.route, event.value,
          body: event.body, typeQuery: event.typeQuery, token: token);

      yield ComponentFetchingSuccess();
      yield ComponentNotFetching();
      if (screen != null) {
        screenBloc.dispatch(ScreenReceived(screen));
      }
    } catch (error) {
      if (error is AuthError) {
        if (tryToRefresh) {
          final String refreshToken = await authRepository.refreshToken;
          if (refreshToken != null) {
            try {
              // refresh and try to send item value again
              await authRepository.refresh();
              yield* _sendItemValue(event);
            } catch (error) {
              if (isRefreshError(error)) {
                yield* _emitAuthError(event);
              } else {
                // didn't refresh because of no connection/server error etc
                yield ComponentFetchingError(error.toString());
              }
            }
          } else {
            // no refresh token stored
            yield* _emitAuthError(event);
          }
          // tryRefresh block end

        } else {
          yield* _emitAuthError(event);
        }
      } else {
        yield ComponentFetchingError(error.toString());
      }
    }
  }

  Stream<ComponentState> _emitAuthError(
      SendingComponentValueRequested event) async* {
    yield ComponentNotFetching();
    screenBloc.dispatch(ComponentAuthError(event.route));
  }
}
