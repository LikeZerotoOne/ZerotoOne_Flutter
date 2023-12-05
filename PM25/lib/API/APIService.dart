import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:pm25/Storage/TokenStorage.dart';
import '../Model/UserModel.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';


class APIService {
  final String _baseUrl = 'http://172.30.2.245:8080';

  Future<http.Response> signUp(User user) {
    return http.post(
      Uri.parse('$_baseUrl/members'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()), // user.toJson()을 json.encode를 사용하여 인코딩
    );
  }

  Future<http.Response> checkUsernameDuplication(String username) async {
    final url = Uri.parse('$_baseUrl/members/$username');
    final response = await http.post(
      url,
      // headers: {'Content-Type': 'application/json'},
      // body: json.encode({"username": username}),
    );
    return response;
  }

  // APIService.dart

  Future<http.Response> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final accessToken = responseData['accessToken'];

      // JWT Parsing 및 memberId 추출
      Map<String, dynamic> decodedToken = Jwt.parseJwt(accessToken);
      int memberId = int.tryParse(decodedToken['memberId'].toString()) ?? 0;

      // memberId 저장
      await saveMemberId(memberId);
    } else {
      // 로그인 실패 처리...
    }
    return response;
  }
  Future<void> saveMemberId(int memberId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('memberId', memberId);
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
  Future<void> logout() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.deleteAllTokens();
  }
  Future<int> updateUser(String name, String email) async {
    final tokenStorage = TokenStorage();
    final accessToken = await tokenStorage.getAccessToken();
    final memberId = await StorageUtil.getMemberId();
    final url = Uri.parse('$_baseUrl/api/members/$memberId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'name': name,
        'email': email,
      }),
    );
    return response.statusCode;
  }
  Future<bool> isAuthenticated() async {
    final tokenStorage = TokenStorage();
    var accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      return false;
    }

    var response = await sendRequestWithToken('api/sample/doA', accessToken);

    if (response.statusCode == 403) { // 액세스 토큰이 만료된 경우
      final success = await refreshToken();
      if (success) {
        accessToken = await tokenStorage.getAccessToken();
        response = await sendRequestWithToken('api/sample/doA', accessToken);
      }
    }

    return response.statusCode == 200;
  }
  Future<http.Response> getMyPageData(int memberId) async {
    final tokenStorage = TokenStorage();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/api/members/$memberId');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> getUserDetails(int memberId) async {
    final tokenStorage = TokenStorage();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/api/members/$memberId');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> getMonthlySchedules(int memberId, int year, int month) async {
    final tokenStorage = TokenStorage();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/api/schedules/monthly?memberId=$memberId&year=$year&month=$month');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> getDailySchedules(int memberId, DateTime date) async {
    final tokenStorage = TokenStorage();
    final accessToken = await tokenStorage.getAccessToken();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date); // 날짜 형식 변경
    final url = Uri.parse('$_baseUrl/api/schedules/daily?memberId=$memberId&date=$formattedDate');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> getScheduleDetails(int scheduleId) async {
    final tokenStorage = TokenStorage();
    final accessToken = await tokenStorage.getAccessToken();
    final url = Uri.parse('$_baseUrl/api/schedules/$scheduleId');

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<int> addSchedule(int memberId, String title, String content, String date) async {
    final accessToken = await TokenStorage().getAccessToken();
    final url = Uri.parse('$_baseUrl/api/schedules');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'memberId': memberId,
        'scheduleTitle': title,
        'scheduleContent': content,
        'scheduleDate': date,
      }),
    );
    return response.statusCode;
  }
  Future<int> updateSchedule(int scheduleId, String title, String content, String date) async {
    final accessToken = await TokenStorage().getAccessToken();
    final url = Uri.parse('$_baseUrl/api/schedules/$scheduleId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'scheduleTitle': title,
        'scheduleContent': content,
        'scheduleDate': date,
      }),
    );

    return response.statusCode;
  }
  Future<int> deleteSchedule(int scheduleId) async {
    final accessToken = await TokenStorage().getAccessToken();
    final url = Uri.parse('$_baseUrl/api/schedules/$scheduleId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  }
}
