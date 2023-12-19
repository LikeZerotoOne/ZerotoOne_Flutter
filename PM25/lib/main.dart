import 'package:flutter/material.dart';
import 'package:pm25/Screen/HomeScreen.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 표시 여부 설정
      theme: ThemeData(
        fontFamily: 'Jua',
        textTheme: TextTheme(
          // 여기서 bold에 해당하는 텍스트 스타일을 일괄적으로 설정합니다.
          bodyText2: TextStyle(
            fontWeight: FontWeight.w500, // FontWeight.bold 대신 사용
          ),
          // 다른 텍스트 스타일들도 필요에 따라 설정 가능
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/HomeScreen': (context) => HomeScreen(),
        '/LoginScreen': (context) => LoginScreen(),
      },
    );
  }
}
