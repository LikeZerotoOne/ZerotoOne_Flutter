import 'package:flutter/material.dart';
import 'package:pm25/Screen/Calendar/CalendarPage.dart';
import 'package:pm25/Screen/MyPage/MyPage.dart';
import 'package:pm25/Screen/Send/SendPage.dart';
import 'package:pm25/Screen/StudyLogPage.dart';


class CommonBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  CommonBottomNavigationBar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: Colors.blue, // 네비게이션 바 배경색 설정
      selectedItemColor: Colors.white, // 선택된 아이템 색상 설정
      unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상 설정
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // 선택된 라벨 스타일 설정
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // 선택되지 않은 라벨 스타일 설정
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'StudyLog'),
        BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MyPage'),

      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudyLogPage()));
            break;
          case 1:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendPage()));
            break;
          case 2:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalendarPage()));
            break;
          case 3:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage()));
            break;
        }
      },
    );
  }
}