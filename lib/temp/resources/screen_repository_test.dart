import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../src/models/screen/screen_model.dart';
import '../../src/resources/screen_repository.dart';

class TestScreenRepository extends ScreenRepository {
  TestScreenRepository();

  String route;

  @override
  Future<ScreenModel> fetchScreen({String query = '', String token}) async {
    route = query;
    final Map<String, dynamic> dmap =
        await parseJsonFromAssets('lib/assets/${replaceSlash(route)}.json');
    return ScreenModel.fromJson(dmap);
  }

  @override
  Future<ScreenModel> sendItemValue(String query, dynamic value,
      {dynamic body, String token}) async {
    final Map<String, dynamic> dmap =
        await parseJsonFromAssets('lib/assets/${replaceSlash(route)}.json');
    return ScreenModel.fromJson(
        updateMap(dmap, route.replaceAll('$route/', ''), value));
  }
}

Map<String, dynamic> updateMap(
    Map<String, dynamic> map, String id, Object value) {
  map.forEach((String key1, dynamic value1) {
    switch (key1) {
      case 'components':
        value1.forEach((dynamic item) {
          item.forEach((String key2, dynamic value2) {
            if (key2 == 'id' && value2 == id) {
              item.update('value', (dynamic value3) => value3 = value);
            }
          });
        });
        break;
    }
  });
  return map;
}

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  return rootBundle.loadString(assetsPath).then((String jsonStr) {
    return json.decode(jsonStr)[0];
  });
}

String replaceSlash(String text) {
  return text.replaceAll('user/', '').replaceAll('/', '.');
}
