import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/Send/SendImagePage.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:pm25/Screen/Send/SendTextPage.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  bool isAuthenticated = false;

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
      });
    }
    else{
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
    // build 내부에서 Navigator를 직접 호출하는 대신, 상태에 따라 화면을 결정
    if (!isAuthenticated) {
      return LoginScreen();
    }

    // 인증된 사용자에 대한 UI 렌더링
    return Scaffold(
      appBar: AppBar(title: Text('Send Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendTextPage()),
              );
            },
            child: Text('텍스트'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendImagePage()),
              );
            },
            child: Text('이미지'),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}