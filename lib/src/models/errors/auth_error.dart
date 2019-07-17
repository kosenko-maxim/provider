class AuthError implements Exception {
  AuthError({this.message, this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
