import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/Keywords/KeywordResultPage.dart';
import 'package:pm25/Screen/Send/MultipleChoice/MultipleChoiceQuestionPage.dart';
import 'package:pm25/Screen/Send/Subjective/NewSubjectiveQuestionResultPage.dart';
import 'package:pm25/Screen/Send/Summary/SummaryResultPage.dart';
import 'package:pm25/Screen/SplashScreen_AI.dart';
import 'package:flutter_svg/flutter_svg.dart';

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


  void createMultipleChoiceQuestions() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    var response = await APIService().createMultipleChoiceQuestions(widget.documentId);

    setState(() {
      isLoading = false; // 로딩 종료
    });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      int documentId = responseData['documentId'];
      List<int> multipleIds = List<int>.from(responseData['multipleIds']);

      // MultipleChoiceQuestionPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultipleChoiceQuestionPage(documentId: documentId, multipleIds: multipleIds),
        ),
      );
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('객관식 문제 생성 실패')),
      );
    }
  }

  void createSubjectiveQuestions() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    var response = await APIService().createSubjectiveQuestions(widget.documentId);

    setState(() {
      isLoading = false; // 로딩 종료
    });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      int documentId = responseData['documentId'];
      List<int> writtenIds = List<int>.from(responseData['writtenIds']);

      // 새로운 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewSubjectiveQuestionResultPage(documentId: documentId, writtenIds: writtenIds),
        ),
      );
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('주관식 문제 생성 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자료 생성',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? SplashScreen_AI() // 로딩 중인 경우
          : Center( // 로딩이 끝난 경우
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              "무엇을 도와드릴까요?",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: extractKeywords,
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/imgs/Keyword.svg',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 70), // 아이콘과 라벨 사이에 일정한 간격을 두기 위해 여백을 추가합니다.
                ],
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '키워드 추출',
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
              onPressed: summarizeParagraph,
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/imgs/Summary.svg',
                    width: 110,
                    height: 110,
                  ),
                  SizedBox(width: 70),
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
              onPressed: createMultipleChoiceQuestions,
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
                  '  객관식 문제 생성',
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
              onPressed: createSubjectiveQuestions,
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
                  '  주관식 문제 생성',
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
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1,),

    );
  }
}