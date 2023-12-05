import 'package:flutter/material.dart';
import 'package:pm25/Screen/HomeScreen.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/Member/SignUpScreen.dart';

void main() {
  runApp(
      MaterialApp(
        home: HomeScreen(),
        // 기타 필요한 속성 ...
        routes: {
          // '/': (context) => HomeScreen(), // 홈 스크린
          '/LoginScreen': (context) => LoginScreen(), // 로그인 스크린
        },
      )

  );
}