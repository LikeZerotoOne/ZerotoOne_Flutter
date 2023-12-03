import 'package:flutter/material.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';

class SendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send")),
      body: Center(child: Text("Send")),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}

// MyPage, StudyLogPage, SendPage에 대해서도 동일한 방식으로 구현
