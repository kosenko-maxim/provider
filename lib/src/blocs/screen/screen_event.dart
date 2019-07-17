import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

import '../../models/screen/screen_model.dart' show ScreenModel;

@immutable
abstract class ScreenEvent extends Equatable {
  ScreenEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class ScreenRequested extends ScreenEvent {
  ScreenRequested({this.route});

  final String route;

  @override
  String toString() => 'ScreenRequested';
}

class ScreenReceived extends ScreenEvent {
  ScreenReceived(this.screen);

  final ScreenModel screen;

  @override
  String toString() => 'ScreenRequested';
}

class ComponentAuthError extends ScreenEvent {
  ComponentAuthError([this.route]) : super(<dynamic>[route]);

  final String route;

  @override
  String toString() => 'ComponentAuthError';
}
