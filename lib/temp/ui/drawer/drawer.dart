import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart'
    show OMIcons;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, BlocBuilder, BlocListener, BlocListenerTree;

import '../../../src/blocs/auth/auth_bloc.dart' show AuthBloc;
import '../../../src/blocs/auth/auth_event.dart' show AuthEvent;
import '../../../src/blocs/auth/auth_state.dart'
    show AuthState, AuthUnauthorized, AuthAuthorized;
import '../../../src/blocs/logout/logout_bloc.dart' show LogOutBloc;
import '../../../src/blocs/logout/logout_event.dart'
    show LogOutEvent, LogoutButtonTapped;
import '../../../src/blocs/logout/logout_state.dart'
    show LogOutError, LogOutNotActive, LogOutSending, LogOutState;
import '../../../src/resources/auth_repository.dart' show AuthRepository;
import '../../../src/ui/components/styled/styled_alert_dialog.dart'
    show StyledAlertDialog;
import '../../../src/ui/components/styled/styled_circular_progress.dart'
    show StyledCircularProgress;
import '../../../src/utils/show_alert.dart' show showError;
import 'drawer_header.dart' show Header;

class DrawerOnly extends StatefulWidget {
  const DrawerOnly({@required this.authBloc});

  final AuthBloc authBloc;

  @override
  State createState() => _DrawerState();
}

class _DrawerState extends State<DrawerOnly> {
  LogOutBloc logOutBloc;

  int _selectedDrawerIndex = 0;

  @override
  void initState() {
    logOutBloc =
        LogOutBloc(authBloc: widget.authBloc, authRepository: AuthRepository());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthEvent, AuthState>(
        bloc: authBloc,
        builder: (BuildContext context, AuthState state) {
          return Drawer(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      (state is AuthAuthorized)
                          ? Header(userProfile: state.userProfile)
                          : Container(),
                      buildListTile(context, 'Market',
                          icon: const Icon(OMIcons.search), position: 0),
                      buildListTile(context, 'Likes',
                          icon: const Icon(OMIcons.favoriteBorder),
                          position: 1),
                      buildDivider(),
                      buildListTile(
                        context,
                        'Message',
                        icon: const Icon(OMIcons.forum),
                        position: 2,
                      ),
                      buildListTile(context, 'Meeting',
                          icon: const Icon(OMIcons.supervisorAccount),
                          position: 3),
                      buildDivider(),
                      buildListTile(context, 'My account',
                          icon: const Icon(OMIcons.accountCircle), position: 3),
                      buildListTile(context, 'Settings',
                          icon: const Icon(OMIcons.settings), position: 6),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        buildDivider(),
                        state is AuthUnauthorized
                            ? buildSignIn(context: context)
                            : buildSignOut(context: context)
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget buildSignOut({@required BuildContext context}) {
    return BlocListenerTree(
        blocListeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<LogOutEvent, LogOutState>(
            bloc: logOutBloc,
            listener: (BuildContext context, LogOutState state) {
              if (state is LogOutError) {
                showError(context, state);
              }
            },
          )
        ],
        child: BlocBuilder<LogOutEvent, LogOutState>(
          bloc: logOutBloc,
          builder: (BuildContext context, LogOutState state) {
            if (state is LogOutNotActive || state is LogOutError) {
              return buildListTile(context, 'Sign out',
                  icon: const Icon(OMIcons.exitToApp),
                  position: 8, onTap: () async {
                final bool logoutApproved = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StyledAlertDialog(
                        title: 'Sign out',
                        content: 'Are you sure you want to sign out?',
                        onOk: () {
                          Navigator.of(context).pop(true);
                        },
                        onCancel: () {
                          Navigator.of(context).pop(false);
                        },
                      );
                    });
                if (logoutApproved) {
                  logOutBloc.dispatch(LogoutButtonTapped());
                }
              });
            }

            if (state is LogOutSending) {
              return buildListTile(context, 'Sign out',
                  loading: true, position: 8);
            }

            return Container(width: 0.0, height: 0.0);
          },
        ));
  }

  Widget buildSignIn({@required BuildContext context}) {
    return buildListTile(context, 'Sign in',
        icon: const Icon(OMIcons.exitToApp), position: 8, onTap: () {
      Navigator.of(context).pushNamed('login');
    });
  }

  Widget buildListTile(BuildContext context, String title,
      {Icon icon, int position, Function onTap, bool loading = false}) {
    return ListTile(
      onTap: loading
          ? null
          : () {
              _selectedDrawerIndex = position;
              onTap();
              Navigator.canPop(context);
            },
      selected: _selectedDrawerIndex == position,
      dense: true,
      leading: Container(
          width: 20,
          height: 20,
          child: loading
              ? StyledCircularProgress(
                  size: 'small', color: Theme.of(context).primaryColor)
              : icon),
      title: Text(title, style: TextStyle(fontSize: 16.0)),
    );
  }

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0, right: 15.0),
      child: Divider(
        color: Color.fromRGBO(66, 65, 65, 0.38),
      ),
    );
  }
}
