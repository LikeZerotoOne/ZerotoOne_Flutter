import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SvgPicture 사용을 위해 추가
import 'package:pm25/Screen/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // 배경을 흰색으로 설정
        child: Center(
          child: SvgPicture.asset(
            'assets/app_logo.svg', // assets 폴더에 있는 SVG 파일 경로 설정
            width: 200, // 원하는 크기로 조절
            height: 200,
          ),
        ),
      ),
    );
  }
}
