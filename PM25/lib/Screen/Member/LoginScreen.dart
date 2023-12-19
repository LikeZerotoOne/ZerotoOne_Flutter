import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/Screen/StudyLog/StudyLogPage.dart';
import 'package:pm25/Storage/TokenStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pm25/Screen/Member/SignUpScreen.dart';

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
        MaterialPageRoute(builder: (context) => StudyLogPage()),
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
    double textFieldWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Text(
                  '테스트 파트너',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 70),
                Container(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: '아이디: ',
                      hintText: '아이디를 입력하세요',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호: ',
                      hintText: '비밀번호를 입력하세요',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('로그인'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF226FA9),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(300, 60),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아직 회원이 아니신가요?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // SignUpScreen으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
