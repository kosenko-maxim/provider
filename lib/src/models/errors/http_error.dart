class HttpError implements Exception {
  HttpError({this.message, this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
