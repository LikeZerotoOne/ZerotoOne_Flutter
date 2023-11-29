import 'package:flutter/material.dart';
import 'package:pm25/Screen/CalendarPage.dart';
import 'package:pm25/Screen/MyPage.dart';
import 'package:pm25/Screen/SendPage.dart';
import 'package:pm25/Screen/StudyLogPage.dart';


class CommonBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  CommonBottomNavigationBar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MyPage'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'StudyLog'),
        BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalendarPage()));
            break;
          case 1:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage()));
            break;
          case 2:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudyLogPage()));
            break;
          case 3:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendPage()));
            break;
        }
      },
    );
  }
}