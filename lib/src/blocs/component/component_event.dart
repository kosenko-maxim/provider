import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

@immutable
abstract class ComponentEvent extends Equatable {
  ComponentEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class SendingComponentValueRequested extends ComponentEvent {
  SendingComponentValueRequested({this.route, this.value, this.body, this.typeQuery});

  final String route;
  final dynamic value;
  final dynamic body;
  final String typeQuery;

  @override
  String toString() => 'SendingComponentValueRequested';
}

class FileUploadingStart extends ComponentEvent {
  @override
  String toString() => 'FileUploadingStart';
}

class FileUploadingCanceled extends ComponentEvent {
  @override
  String toString() => 'FileUploadingCanceled';
}
