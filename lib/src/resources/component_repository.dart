import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:image/image.dart' as img;

import '../models/screen/screen_model.dart' show ScreenModel;
import 'api/component_api.dart' show ComponentApi;

class ComponentRepository {
  final ComponentApi componentApi = ComponentApi();

  Future<ScreenModel> sendItemValue(String query, dynamic value,
      {dynamic body, String token, String typeQuery}) async {
    ScreenModel screen;
    if (body is File) {
      screen = await componentApi.uploadImage(
          query: query,
          value: value,
          token: token,
          jpg: img.encodeJpg(img.decodeImage(body.readAsBytesSync())));
    } else {
      screen = await componentApi.sendComponentValue(
          query: query, value: value, token: token, typeQuery: typeQuery);
    }

    return screen;
  }
}
