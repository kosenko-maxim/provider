import '../../../models/errors/http_error.dart' show HttpError;

bool isRefreshError(Exception error) {
  return error is HttpError && error.statusCode.toString().startsWith('4');
}
