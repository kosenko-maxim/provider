import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

@immutable
abstract class LogOutState extends Equatable {
  LogOutState([List<dynamic> props = const <dynamic>[]]) : super(props);

  @override
  String toString();
}

class LogOutSending extends LogOutState {
  @override
  String toString() => 'LogOutSending';
}

class LogOutNotActive extends LogOutState {
  @override
  String toString() => 'LogOutNotActive';
}

class LogOutError extends LogOutState {
  LogOutError([this.message]) : super(<String>[message]);

  final String message;

  @override
  String toString() => message;
}
