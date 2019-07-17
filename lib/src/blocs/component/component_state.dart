import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

@immutable
abstract class ComponentState extends Equatable {
  ComponentState([List<dynamic> props = const <dynamic>[]]) : super(props);

  @override
  String toString();
}

class ComponentNotFetching extends ComponentState {
  @override
  String toString() => 'ComponentInitState';
}

class ComponentIsFetching extends ComponentState {
  @override
  String toString() => 'ComponentIsFetching';
}

class ComponentFetchingSuccess extends ComponentState {
  @override
  String toString() => 'ComponentFetchingSuccess';
}

class ComponentFetchingError extends ComponentState {
  ComponentFetchingError([this.message]);

  final String message;

  @override
  String toString() => message;
}
