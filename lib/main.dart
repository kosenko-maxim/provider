import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart' show Bloc, BlocSupervisor, BlocDelegate;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;

import 'src/app.dart' show App;
import 'src/blocs/auth/auth_bloc.dart' show AuthBloc;
import 'src/resources/auth_repository.dart' show AuthRepository;
//import 'temp/app_old.dart';

class AppBlocDelegate extends BlocDelegate {
  @override
  void onError(
      Bloc<dynamic, dynamic> bloc, Object error, StackTrace stacktrace) {
    print('bloc error: $error');
    print('===> error.runtimeType: ${error.runtimeType}');
    super.onError(bloc, error, stacktrace);
  }
}

void main() {
//  debugPaintSizeEnabled = true;
  BlocSupervisor.delegate = AppBlocDelegate();
  final AuthRepository authRepository = AuthRepository();
  final AuthBloc authBloc = AuthBloc(authRepository: authRepository);
  runApp(BlocProvider<AuthBloc>(
    builder: (BuildContext context) => authBloc,
    child: App(authBloc: authBloc),
  ));
}
