import 'package:http/http.dart' as http;
import '../Model/UserModel.dart';
import 'dart:convert';

class APIService {
  final String _baseUrl = 'http://172.30.19.3:8080';

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

}

