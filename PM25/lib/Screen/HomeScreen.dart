  import 'package:flutter/material.dart';
  import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
  import 'package:pm25/Screen/Member/LoginScreen.dart';
  import 'package:pm25/Screen/Member/SignUpScreen.dart';

  class HomeScreen extends StatelessWidget {
    final APIService _apiService = APIService();

    void _testToken(BuildContext context) async {
      final response = await _apiService.getWithToken('api/sample/doA');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 성공!')),
        );
      } else if (response.statusCode == 403) {
        final refreshTokenSuccess = await _apiService.refreshToken();
        if (refreshTokenSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Access Token 재발급 성공')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Refresh Token 만료, 로그인 필요')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 요청 실패')),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      final apiService = APIService();

      // Refresh Token 만료 시 로그인 페이지로 이동하는 콜백 설정
      apiService.onRefreshTokenExpired = () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      };
      return Scaffold(
        appBar: AppBar(
          title: Text('PM25 앱 홈'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text('로그인'),
                onPressed: () {
                  // LoginScreen으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              SizedBox(height: 20), // 버튼 사이의 간격을 주기 위한 SizedBox
              ElevatedButton(
                child: Text('회원가입'),
                onPressed: () {
                  // SignUpScreen으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('토큰 인증 테스트'),
                onPressed: () => _testToken(context),
              ),

            ],

          ),
        ),
        bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),

      );
    }
  }