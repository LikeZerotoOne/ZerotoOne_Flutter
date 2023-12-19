import 'package:flutter/material.dart';
import 'package:pm25/Screen/Calendar/CalendarPage.dart';
import 'package:pm25/Screen/MyPage/MyPage.dart';
import 'package:pm25/Screen/send/SendPage.dart';
import 'package:pm25/Screen/StudyLog/StudyLogPage.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CommonBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CommonBottomNavigationBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SizedBox(
            width: 60,
            height: 60,
            child: SvgPicture.asset('assets/imgs/study_past.svg', width: 60, height: 60),
          ),
          label: '나의 공부내역',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            width: 60,
            height: 60,
            child: SvgPicture.asset('assets/imgs/AI.svg', width: 60, height: 60),
          ),
          label: '자료 생성',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            width: 60,
            height: 60,
            child: SvgPicture.asset('assets/imgs/calender.svg', width: 60, height: 60),
          ),
          label: '캘린더',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            width: 60,
            height: 60,
            child: SvgPicture.asset('assets/imgs/my_page.svg', width: 60, height: 60),
          ),
          label: '마이페이지',
        ),
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  MyPage()));
            break;
        }
      },
    );
  }
}