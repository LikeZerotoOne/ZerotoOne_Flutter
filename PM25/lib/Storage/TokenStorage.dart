import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = FlutterSecureStorage();

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }
  Future<void> saveAccessTokens( String accessToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  Future<void> deleteAllTokens() async {
    await _storage.deleteAll();
  }
}
