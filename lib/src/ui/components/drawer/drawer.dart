import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart'
    show OMIcons;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, BlocBuilder, BlocListener, BlocListenerTree;

import '../../../blocs/auth/auth_bloc.dart' show AuthBloc;
import '../../../blocs/auth/auth_event.dart' show AuthEvent;
import '../../../blocs/auth/auth_state.dart' show AuthState, AuthUnauthorized;
import '../../../blocs/logout/logout_bloc.dart' show LogOutBloc;
import '../../../blocs/logout/logout_event.dart'
    show LogOutEvent, LogoutButtonTapped;
import '../../../blocs/logout/logout_state.dart'
    show LogOutError, LogOutNotActive, LogOutSending, LogOutState;
import '../../../resources/auth_repository.dart' show AuthRepository;
import '../../../utils/show_alert.dart' show showError;

import '../styled/styled_alert_dialog.dart' show StyledAlertDialog;
import '../styled/styled_circular_progress.dart' show StyledCircularProgress;
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
                      Header(
                        state: state,
                      ),
                      buildListTile(
                        context,
                        'Add property',
                        icon: OMIcons.addCircleOutline,
                        position: 0,
                        colorIcon: const Color.fromRGBO(63, 180, 188, 1),
                        colorText: const Color.fromRGBO(63, 180, 188, 1),
                      ),
                      buildListTile(
                        context,
                        'Contact us',
                        icon: OMIcons.mailOutline,
                        position: 1,
                        colorIcon: const Color.fromRGBO(63, 180, 188, 1),
                        colorText: const Color.fromRGBO(63, 180, 188, 1),
                        onTap: () {},
                      ),
                      const Divider(
                        color: Color.fromRGBO(66, 65, 65, 0.38),
                      ),
                      buildListTile(context, 'Property',
                          onTap: () {}, icon: OMIcons.search, position: 2),
                      buildListTile(context, 'Favorits',
                          onTap: () {},
                          icon: OMIcons.favoriteBorder,
                          position: 3),
                      buildDivider(),
                      buildListTile(
                        context,
                        'Message',
                        onTap: () {},
                        icon: OMIcons.forum,
                        position: 4,
                      ),
                      buildListTile(context, 'Calendar',
                          onTap: () {}, icon: OMIcons.event, position: 5),
                      buildDivider(),
                      buildListTile(context, 'My account',
                          onTap: () {},
                          icon: OMIcons.accountCircle,
                          position: 6),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 24.0, right: 16),
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Column(
                          children: <Widget>[
                            buildDivider(),
                            state is AuthUnauthorized
                                ? buildSignIn(context: context)
                                : buildSignOut(context: context),
                          ],
                        )))
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
                  icon: OMIcons.exitToApp, position: 7, onTap: () async {
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
        icon: OMIcons.exitToApp, position: 7, onTap: () {
      Navigator.of(context).pushNamed('login');
    });
  }

  Widget buildListTile(
    BuildContext context,
    String title, {
    IconData icon,
    int position,
    Function onTap,
    bool loading = false,
    Color colorIcon = const Color.fromRGBO(117, 116, 116, 1),
    Color colorText = const Color.fromRGBO(0, 0, 0, 0.87),
  }) {
    return InkWell(
      onTap: loading
          ? null
          : () {
              setState(() {
                _selectedDrawerIndex = position;
              });
              onTap();
              Navigator.canPop(context);
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 32),
              child: Container(
                width: 24,
                height: 24,
                child: Center(
                    child: loading
                        ? StyledCircularProgress(
                            size: 'small',
                            color: Theme.of(context).primaryColor)
                        : Icon(
                            icon,
                            color: _selectedDrawerIndex == position
                                ? const Color.fromRGBO(63, 180, 188, 1)
                                : colorIcon,
                          )),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: _selectedDrawerIndex == position
                      ? const Color.fromRGBO(63, 180, 188, 1)
                      : colorText),
            ),
          ],
        ),
      ),
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
