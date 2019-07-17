import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

import 'package:user_mobile/src/models/auth/user_info.dart' show UserInfo;

@immutable
abstract class AuthState extends Equatable {
  AuthState([List<dynamic> props = const <dynamic>[]]) : super(props);

  @override
  String toString();
}

class AuthUnauthorized extends AuthState {
  @override
  String toString() => 'AuthUnauthorized';
}

class AuthAuthorized extends AuthState {
  AuthAuthorized([this.userProfile]) : super(<dynamic>[userProfile]);

  final UserInfo userProfile;

  UserInfo get usPr => userProfile;

  @override
  String toString() => 'AuthAuthorized';
}

class IsFetchingLogout extends AuthState {
  @override
  String toString() => 'IsFetchingLogout';
}
