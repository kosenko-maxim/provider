import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

@immutable
abstract class LogOutEvent extends Equatable {
  LogOutEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class LogoutButtonTapped extends LogOutEvent {
  @override
  String toString() => 'LogoutButtonTapped';
}
