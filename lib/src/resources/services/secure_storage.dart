import 'package:meta/meta.dart' show required;

import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;

class SecureStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> write({@required String key, @required String value}) {
    return _storage.write(key: key, value: value);
  }

  Future<String> read({@required String key}) {
    return _storage.read(key: key);
  }

  Future<void> delete({@required String key}) {
    return _storage.delete(key: key);
  }

  Future<Map<String, String>> readAll() {
    return _storage.readAll();
  }

  Future<void> deleteAll() {
    return _storage.deleteAll();
  }
}
