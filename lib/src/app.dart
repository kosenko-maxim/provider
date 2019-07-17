import 'package:meta/meta.dart' show required;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, BlocListener, BlocBuilder;

import 'blocs/auth/auth_bloc.dart' show AuthBloc;
import 'blocs/auth/auth_event.dart' show AuthEvent, AppStarted;
import 'blocs/auth/auth_state.dart' show AuthState, AuthUnauthorized;

import 'constants/navigation.dart' show ROOT_PAGE, LOGIN_PAGE;
import 'pallete.dart' show accentColor, primaryColor;
import 'typography.dart' show customTextTheme;

import 'ui/pages/login/phone.dart' show PhoneScreen;
import 'ui/pages/screen.dart' show Screen;

class App extends StatefulWidget {
  const App({@required this.authBloc});

  final AuthBloc authBloc;

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  void initState() {
    widget.authBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = widget.authBloc;
    return BlocBuilder<AuthEvent, AuthState>(
      bloc: authBloc,
      builder: (BuildContext context, AuthState state) {
        return MaterialApp(
          title: '4u.house',
          theme: ThemeData(
              accentColor: accentColor,
              primaryColor: primaryColor,
              textTheme: customTextTheme),
          home: Screen(authBloc: authBloc, route: ROOT_PAGE),
          onGenerateRoute: (RouteSettings settings) {
            final String name = settings.name;
            final Map<String, dynamic> arguments = settings.arguments;
            switch (name) {
              case LOGIN_PAGE:
                return MaterialPageRoute<PhoneScreen>(
                  builder: (BuildContext context) => PhoneScreen(
                    authBloc: authBloc,
                    arguments: arguments,
                  ),
                );
              default:
                return MaterialPageRoute<Screen>(
                    builder: (BuildContext context) => Screen(
                          authBloc: authBloc,
                          route: name,
                        ));
            }
          },
        );
      },
    );
  }
}
