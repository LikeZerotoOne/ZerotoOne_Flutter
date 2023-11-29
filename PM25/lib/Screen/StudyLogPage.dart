import 'package:flutter/material.dart';
import 'package:pm25/CommonBottomNavigationBar.dart';

class StudyLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calend")),
      body: Center(child: Text("Caar Page")),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }
}

// MyPage, StudyLogPage, SendPage에 대해서도 동일한 방식으로 구현
