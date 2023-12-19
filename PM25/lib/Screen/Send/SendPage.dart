import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/Send/SendImagePage.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:pm25/Screen/Send/SendTextPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  bool isAuthenticated = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    authenticateUser();
  }

  void authenticateUser() async {
    final memberId = await StorageUtil.getMemberId();
    bool result = await APIService().authenticateUser(memberId);
    if (result) {
      setState(() {
        isAuthenticated = true;
        isLoading = false;
      });
    } else {
      // initState에서 Navigator 호출 시 문제 발생을 피하기 위해
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SplashScreen_Loading();
    } else if (!isAuthenticated) {
      return LoginScreen();
    }


// 인증된 사용자에 대한 UI 렌더링
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자료 생성',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "원하시는 학습자료를 만들기 위해 하나를 선택해 주세요!",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SendTextPage()),
                );
              },
              icon: SvgPicture.asset(
                'assets/imgs/text.svg',
                width: 100,
                height: 100,
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '텍스트',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width, 150),
                padding: EdgeInsets.all(16.0),
                side: BorderSide.none,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SendImagePage()),
                );
              },
              icon: SvgPicture.asset(
                'assets/imgs/image.svg',
                width: 100,
                height: 100,
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '이미지',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width, 150),
                padding: EdgeInsets.all(16.0),
                side: BorderSide.none,
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}