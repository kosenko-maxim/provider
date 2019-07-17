import 'dart:async' show Future;

import '../models/screen/screen_model.dart' show ScreenModel;
import 'api/screen_api.dart' show ScreenApi;

class ScreenRepository {
  final ScreenApi screenApi = ScreenApi();

  Future<ScreenModel> fetchScreen({String query = '', String token}) async {
    final Map<String, dynamic> response =
        await screenApi.fetchScreen(route: query, token: token);
    return ScreenModel.fromJson(response);
  }
}
