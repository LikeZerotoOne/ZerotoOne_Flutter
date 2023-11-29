// LoginScreen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/Screen/HomeScreen.dart';
import 'package:pm25/TokenStorage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = APIService();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final response = await _apiService.login(username, password);

    if (response.statusCode == 200) {
      // 응답으로부터 JSON 데이터 추출
      final responseData = json.decode(response.body);
      final accessToken = responseData['accessToken'];
      final refreshToken = responseData['refreshToken'];

      // 토큰을 로그로 출력
      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');
      // TokenStorage를 사용하여 토큰 저장
      final tokenStorage = TokenStorage();
      await tokenStorage.saveTokens(accessToken, refreshToken);
      

      // 로그인 성공 처리, 예를 들면 홈 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 성공')),

      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

    } else {
      // 로그인 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
