import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:pm25/Storage/TokenStorage.dart';
import '../Model/UserModel.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';


class APIService {
  final String _baseUrl = 'http://192.9.13.244:8080';

  Future<http.Response> signUp(User user) {
    return http.post(
      Uri.parse('$_baseUrl/members'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()), // user.toJson()을 json.encode를 사용하여 인코딩
    );
  }

  Future<http.Response> checkUsernameDuplication(String username) async {
    final url = Uri.parse('$_baseUrl/members/$username');
    final response = await http.get(url);
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
  Future<bool> authenticateUser(int memberId) async {
    final accessToken = await TokenStorage().getAccessToken();
    final url = Uri.parse('$_baseUrl/api/members/auth/$memberId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode == 200;
  }
  Future<http.Response> postTextData({required String source, required String target, required String text, required int memberId, required String documentTitle}) async {
    var url = Uri.parse('$_baseUrl/api/documents/text');
    var accessToken = await TokenStorage().getAccessToken();

    var request = http.MultipartRequest('POST', url)
      ..fields['source'] = source
      ..fields['target'] = target
      ..fields['text'] = text
      ..fields['memberId'] = memberId.toString()
      ..fields['documentTitle'] = documentTitle
      ..headers.addAll({
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: 'multipart/form-data',
      });

    var response = await request.send();
    return await http.Response.fromStream(response);
  }
  Future<http.Response> sendImage({
    required File imageFile,
    required String documentTitle,
    required int memberId,
  }) async {
    var url = Uri.parse('$_baseUrl/api/documents/img');
    var accessToken = await TokenStorage().getAccessToken(); // Access Token 가져오기

    var request = http.MultipartRequest('POST', url)
      ..fields['memberId'] = memberId.toString()
      ..fields['documentTitle'] = documentTitle
      ..headers['Authorization'] = 'Bearer $accessToken';

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

    return await request.send().then((result) async {
      return await http.Response.fromStream(result);
    });
  }
  Future<http.Response> getDocumentDetails(int documentId) async {
    final url = Uri.parse('$_baseUrl/api/documents/$documentId');
    final accessToken = await TokenStorage().getAccessToken();

    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> deleteDocument(int documentId) async {
    var url = Uri.parse('$_baseUrl/api/documents/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    return await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> extractKeywords(int documentId) async {
    final url = Uri.parse('$_baseUrl/api/keywords/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<List<dynamic>> fetchKeywords(int documentId) async {
    var url = Uri.parse('$_baseUrl/api/keywords/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',

        // Include authorization header if needed
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes)); // UTF-8 디코딩
      return data['keywords'];
    } else {
      // Handle error
      throw Exception('Failed to load keywords');
    }
  }
  Future<http.Response> deleteKeywords(int documentId) async {
    var url = Uri.parse('$_baseUrl/api/keywords/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    return await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> summarizeParagraph(int documentId) async {
    var url = Uri.parse('$_baseUrl/api/contexts/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> fetchSummaryResults(int documentId) async {
    var url = Uri.parse('$_baseUrl/api/contexts/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    return await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> deleteSummaryResults(int documentId) async {
    var url = Uri.parse('$_baseUrl/api/contexts/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    return await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> fetchDocuments(int memberId) async {
    var url = Uri.parse('$_baseUrl/api/documents/mainPage/$memberId');
    var accessToken = await TokenStorage().getAccessToken(); // Access Token 가져오기

    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> fetchDocumentDetails(int documentId) async {
    var url = Uri.parse('$_baseUrl/api/documents/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    return await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> createMultipleChoiceQuestions(int documentId) async {
    final url = Uri.parse('$_baseUrl/api/multiples/$documentId');
    var accessToken = await TokenStorage().getAccessToken();

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
  Future<http.Response> getMultipleChoiceQuestions(int documentId, List<int> multipleIds) async {
    var uri = Uri.parse('$_baseUrl/api/multiples/result?documentId=$documentId' +
        multipleIds.map((id) => '&multipleIds=$id').join());

    var accessToken = await TokenStorage().getAccessToken(); // accesstoken 가져오기

    return await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
  }
  Future<http.Response> deleteMultipleChoiceQuestions(int documentId, List<int> multipleIds) async {
    var url = Uri.parse('$_baseUrl/api/multiples/result');
    var accessToken = await TokenStorage().getAccessToken(); // accesstoken 가져오기
    var body = jsonEncode({
      'documentId': documentId,
      'multipleIds': multipleIds,
    });

    var response = await http.delete(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken', // 여기서 토큰은 적절하게 설정
    });

    return response;
  }
  Future<http.Response> getKeywords(int documentId) async {
    var url = Uri.parse('$_baseUrl/api/keywords/$documentId'); // 서버 URL 수정
    var accessToken = await TokenStorage().getAccessToken(); // accesstoken 가져오기

    var response = await http.get(url, headers: {
      // 요청 헤더 설정
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
    return response;
  }
  Future<http.Response> getSummary(int documentId) async {
    var accessToken = await TokenStorage().getAccessToken(); // accesstoken 가져오기

    var url = Uri.parse('$_baseUrl/api/contexts/$documentId'); // 서버 URL 수정
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
    return response;
  }
  Future<http.Response> getMultipleChoice(int documentId) async {
    var accessToken = await TokenStorage().getAccessToken(); // accesstoken 가져오기

    var url = Uri.parse('$_baseUrl/api/multiples/$documentId'); // 서버 URL 수정
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',    });
    return response;
  }
  Future<http.Response> getMultipleChoiceDetail(int documentId, int multipleId) async {
    var accessToken = await TokenStorage().getAccessToken(); // accesstoken 가져오기

    var url = Uri.parse('$_baseUrl/api/multiples?documentId=$documentId&multipleId=$multipleId'); // URL 수정
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',       });
    return response;
  }
  Future<http.Response> deleteMultipleChoice(int documentId, int multipleId) async {
    var url = Uri.parse('$_baseUrl/api/multiples'); // URL 수정
    var accessToken = await TokenStorage().getAccessToken(); // accesstoken 가져오기

    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',       },
      body: jsonEncode({
        'documentId': documentId,
        'multipleId': multipleId,
      }),
    );
    return response;
  }
}

