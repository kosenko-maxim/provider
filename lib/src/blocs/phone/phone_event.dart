import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

@immutable
abstract class PhoneEvent extends Equatable {
  PhoneEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class PhoneCountriesDataRequested extends PhoneEvent {
  @override
  String toString() => 'PhoneCountriesDataRequested';
}
