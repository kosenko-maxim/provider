import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

@immutable
abstract class LoginState extends Equatable {
  LoginState([List<dynamic> props = const <dynamic>[]]) : super(props);

  @override
  String toString();
}

class PhoneEntering extends LoginState {
  @override
  String toString() => 'PhoneEntering';
}

class IsFetchingOtp extends LoginState {
  @override
  String toString() => 'isFetchingOtp';
}

class IsFetchingCode extends LoginState {
  @override
  String toString() => 'isFetchingCode';
}

class OtpSent extends LoginState {
  @override
  String toString() => 'OtpSent';
}

class PhoneError extends LoginState {
  PhoneError([this.message]) : super(<String>[message]);

  final String message;

  @override
  String toString() => message;
}

class CodeError extends LoginState {
  CodeError([this.message]) : super(<String>[message]);

  final String message;

  @override
  String toString() => message;
}
