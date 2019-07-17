import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable, required;

import '../../models/auth/phone_model.dart' show UserModel;

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class AppStarted extends AuthEvent {
  @override
  String toString() => 'AppStarted';
}

class UserLoggedIn extends AuthEvent {
  @override
  String toString() => 'UserLoggedIn';
}

class UserLoggedOut extends AuthEvent {
  @override
  String toString() => 'UserLoggedOut';
}

class RefreshTokenFailed extends AuthEvent {
  @override
  String toString() => 'RefreshTokenFailed';
}
