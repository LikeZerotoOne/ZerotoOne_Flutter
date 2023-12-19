import 'package:flutter/material.dart';

class SplashScreen_Loading extends StatefulWidget {
  @override
  _SplashScreen_LoadingState createState() => _SplashScreen_LoadingState();
}

class _SplashScreen_LoadingState extends State<SplashScreen_Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/AI_jump.gif', // 실제 GIF 파일 경로로 대체하세요.
              width: 200,
              height: 200,
            ),
            SizedBox(height: 40.0),
            Text("앱을 로딩 중입니다."),

          ],
        ),
      ),
    );
  }
}
