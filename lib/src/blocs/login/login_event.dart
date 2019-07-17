import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable, required;

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class OtpRequested extends LoginEvent {
  OtpRequested({@required this.phoneCountryId,
    @required this.phoneNumber})
      : super(<dynamic>[phoneNumber]);

  final String phoneCountryId;
  final String phoneNumber;

  @override
  String toString() => 'OtpRequested';
}

class SubmitCodeTapped extends LoginEvent {
  SubmitCodeTapped(
      {@required this.phoneNumber, @required this.otp, @required this.phoneCountryId})
      : super(<dynamic>[phoneNumber, otp, phoneCountryId]);

  final String phoneNumber;
  final String phoneCountryId;
  final String otp;

  @override
  String toString() => 'SubmitCodeTapped';
}

class CodeEnteringCanceled extends LoginEvent {
  @override
  String toString() => 'CodeEnteringCanceled';
}
