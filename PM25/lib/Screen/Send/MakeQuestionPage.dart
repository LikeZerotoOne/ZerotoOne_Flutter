import 'package:flutter/material.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';

class MakeQuestionPage extends StatefulWidget {
  final int documentId;

  MakeQuestionPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _MakeQuestionPageState createState() => _MakeQuestionPageState();
}

class _MakeQuestionPageState extends State<MakeQuestionPage> {
  @override
  void initState() {
    super.initState();
    print("Received Document ID: ${widget.documentId}");
  }  // 키워드 추출 기능을 위한 함수
  void extractKeywords() {
    // 키워드 추출 로직 또는 페이지 이동
  }

  // 문단 요약 기능을 위한 함수
  void summarizeParagraph() {
    // 문단 요약 로직 또는 페이지 이동
  }

  // 객관식 문제 생성 기능을 위한 함수
  void createMultipleChoiceQuestions() {
    // 객관식 문제 생성 로직 또는 페이지 이동
  }

  // 주관식 문제 생성 기능을 위한 함수
  void createSubjectiveQuestions() {
    // 주관식 문제 생성 로직 또는 페이지 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Questions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: extractKeywords,
              child: Text('키워드 추출'),
            ),
            ElevatedButton(
              onPressed: summarizeParagraph,
              child: Text('문단 요약'),
            ),
            ElevatedButton(
              onPressed: createMultipleChoiceQuestions,
              child: Text('객관식 문제'),
            ),
            ElevatedButton(
              onPressed: createSubjectiveQuestions,
              child: Text('주관식 문제'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1,),

    );
  }
}