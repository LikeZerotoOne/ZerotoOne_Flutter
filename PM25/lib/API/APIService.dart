import 'package:http/http.dart' as http;
import 'package:pm25/TokenStorage.dart';
import '../Model/UserModel.dart';
import 'dart:convert';
import 'dart:ui';

class APIService {
  final String _baseUrl = 'http://172.30.1.100:8080';

  Future<http.Response> signUp(User user) {
    return http.post(
      Uri.parse('$_baseUrl/members/signUp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()), // user.toJson()을 json.encode를 사용하여 인코딩
    );
  }

  Future<http.Response> checkUsernameDuplication(String username) async {
    final url = Uri.parse('$_baseUrl/members/checkUsername/$username');
    final response = await http.post(
      url,
      // headers: {'Content-Type': 'application/json'},
      // body: json.encode({"username": username}),
    );
    return response;
  }

  // APIService.dart

  Future<http.Response> login(String username, String password) {
    return http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
  }

  Future<http.Response> getWithToken(String endpoint) async {
    final tokenStorage = TokenStorage();
    String? accessToken = await tokenStorage.getAccessToken();
    var response = await sendRequestWithToken(endpoint, accessToken);

    if (response.statusCode == 403) {
      final success = await refreshToken();
      if (success) {
        accessToken = await tokenStorage.getAccessToken();
        response = await sendRequestWithToken(endpoint, accessToken);
      } else {
        // 토큰 갱신 실패 시 처리
        // 예: 사용자에게 알림 표시 및 로그인 화면으로 리다이렉트
      }
    }

    return response;
  }

  Future<http.Response> sendRequestWithToken(String endpoint,
      String? token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await http.get(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
  }

// Refresh Token 만료 시 호출될 콜백 함수
  VoidCallback? onRefreshTokenExpired;

  Future<bool> refreshToken() async {
    final tokenStorage = TokenStorage();
    final refreshToken = await tokenStorage.getRefreshToken();

    if (refreshToken == null) {
      onRefreshTokenExpired?.call();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/refreshToken'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['accessToken'] != null) {
          await tokenStorage.saveAccessTokens(data['accessToken']);
          return true;
        }
        return false;
      } else {
        await tokenStorage.deleteAllTokens();
        onRefreshTokenExpired?.call();
        return false;
      }
    } catch (e) {
      print('Error during token refresh: $e');
      return false;
    }
  }
}
