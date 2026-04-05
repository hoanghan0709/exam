import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  // write
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // read
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // delete
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // delete all
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.read(secureStorageProvider);
  return SecureStorageService(storage);
});

//path
class StorageKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const userLogged = 'user_logged';
}
