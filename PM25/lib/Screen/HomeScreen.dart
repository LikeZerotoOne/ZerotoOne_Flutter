import 'package:flutter/material.dart';
import 'package:pm25/Screen/LoginScreen.dart';
import 'package:pm25/Screen/SignUpScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}