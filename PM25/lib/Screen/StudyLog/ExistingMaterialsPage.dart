import 'package:flutter/material.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/StudyLog/KeywordsPage.dart';
import 'package:pm25/Screen/StudyLog/MultipleChoiceListPage.dart';
import 'package:pm25/Screen/StudyLog/SubjectiveQuestionsListPage.dart';
import 'package:pm25/Screen/StudyLog/SummaryPage.dart';

class ExistingMaterialsPage extends StatelessWidget {
  final int documentId;

  ExistingMaterialsPage({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Materials'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KeywordsPage(documentId: documentId),
                  ),
                );
              },
              child: Text('키워드'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryPage(documentId: documentId),
                  ),
                );
              },
              child: Text('문단 요약'),
            ),
            // ExistingMaterialsPage 클래스 내에서
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultipleChoiceListPage(documentId: documentId),
                  ),
                );
              },
              child: Text('객관식 문제'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectiveQuestionsListPage(documentId: documentId),
                  ),
                );              },
              child: Text('주관식 문제'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),

    );
  }
}
