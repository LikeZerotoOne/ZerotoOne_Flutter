import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveToken(String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<String?> get accessToken async {
    return _storage.read(key: 'accessToken');
  }

  Future<String?> get refreshToken async {
    return _storage.read(key: 'refreshToken');
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
