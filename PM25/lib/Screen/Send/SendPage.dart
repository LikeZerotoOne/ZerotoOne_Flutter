import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text('Send Page')),
        body: Center(child: CircularProgressIndicator()),
      );
    }


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
              );            },
            child: Text('텍스트'),
          ),
          ElevatedButton(
            onPressed: () {
              // '이미지' 버튼 클릭 시 작업
            },
            child: Text('이미지'),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1,),

    );
  }
}