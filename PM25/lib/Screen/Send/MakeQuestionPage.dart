import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/Keywords/KeywordResultPage.dart';
import 'package:pm25/Screen/Send/Summary/SummaryResultPage.dart';

class MakeQuestionPage extends StatefulWidget {
  final int documentId;

  MakeQuestionPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _MakeQuestionPageState createState() => _MakeQuestionPageState();
}


class _MakeQuestionPageState extends State<MakeQuestionPage> {
  bool isLoading = false; // 로딩 상태를 추적하는 변수 추가

  @override
  void initState() {
    super.initState();
    print("Received Document ID: ${widget.documentId}");
  }  // 키워드 추출 기능을 위한 함수
  void extractKeywords() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });
    var response = await APIService().extractKeywords(widget.documentId);
    setState(() {
      isLoading = false; // 로딩 종료
    });
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      int receivedDocumentId = responseData['documentId'];

      // 새 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KeywordResultPage(documentId: receivedDocumentId),
        ),
      );
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('키워드 추출 실패')),
      );
    }
  }
  void summarizeParagraph() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    var response = await APIService().summarizeParagraph(widget.documentId);

    setState(() {
      isLoading = false; // 로딩 종료
    });

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryResultPage(documentId: widget.documentId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문단 요약 실패')),
      );
    }
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중인 경우
          : Center( // 로딩이 끝난 경우
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