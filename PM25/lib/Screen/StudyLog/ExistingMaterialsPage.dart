import 'package:flutter/material.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MultipleChoice/MultipleChoiceQuestionPage.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';
import 'package:pm25/Screen/StudyLog/KeywordsPage.dart';
import 'package:pm25/Screen/StudyLog/MultipleChoiceListPage.dart';
import 'package:pm25/Screen/StudyLog/SubjectiveQuestionsListPage.dart';
import 'package:pm25/Screen/StudyLog/SummaryPage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExistingMaterialsPage extends StatelessWidget {
  final int documentId;

  ExistingMaterialsPage({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 공부내역',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              "기존에 생성된 자료를 확인해보세요!",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KeywordsPage(documentId: documentId),
                  ),
                );
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/imgs/Keyword.svg',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 60), // 아이콘과 라벨 사이에 일정한 간격을 두기 위해 여백을 추가합니다.
                ],
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '키워드',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width, 100),
                padding: EdgeInsets.all(16.0),
                side: BorderSide.none,
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryPage(documentId: documentId),
                  ),
                );
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/imgs/Summary.svg',
                    width: 110,
                    height: 110,
                  ),
                  SizedBox(width: 40),
                ],
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '문단 요약',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width, 100),
                padding: EdgeInsets.all(16.0),
                side: BorderSide.none,
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultipleChoiceListPage(documentId: documentId,),
                  ),
                );
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/imgs/Multiple_choice.svg',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 30),
                ],
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '객관식 문제',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width, 100),
                padding: EdgeInsets.all(16.0),
                side: BorderSide.none,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectiveQuestionsListPage(documentId: documentId),
                  ),
                );              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/imgs/Subjective_question.svg',
                    width: 100,
                    height: 100,
                  ),SizedBox(width: 30),
                ],
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '주관식 문제',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                fixedSize: Size(MediaQuery.of(context).size.width, 100),
                padding: EdgeInsets.all(16.0),
                side: BorderSide.none,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0,),

    );
  }
}
