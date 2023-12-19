import 'package:flutter/material.dart';

class SplashScreen_AI extends StatefulWidget {
  @override
  _SplashScreen_AIState createState() => _SplashScreen_AIState();
}

class _SplashScreen_AIState extends State<SplashScreen_AI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/AI_book.gif', // 실제 GIF 파일 경로로 대체하세요.
              width: 200,
              height: 200,
            ),
            SizedBox(height: 40.0),
            Text("AI가 자료를 생성중입니다."),
            Text("네트워크 환경에 따라 30초 에서 2분정도 소요될 수 있습니다."),
          ],
        ),
      ),
    );
  }
}