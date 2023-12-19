import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';
import 'package:pm25/Screen/StudyLog/SubjectiveQuestionDetailPage.dart';

class SubjectiveQuestionsListPage extends StatefulWidget {
  final int documentId;

  SubjectiveQuestionsListPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _SubjectiveQuestionsListPageState createState() => _SubjectiveQuestionsListPageState();
}

class _SubjectiveQuestionsListPageState extends State<SubjectiveQuestionsListPage> {
  bool isLoading = true;
  List<dynamic> writtenQuestions = [];

  @override
  void initState() {
    super.initState();
    fetchWrittenQuestions();
  }

  void fetchWrittenQuestions() async {
    var response = await APIService().getWrittenQuestions(widget.documentId);
    if (response.statusCode == 200) {
      setState(() {
        writtenQuestions = json.decode(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 공부내역 - 주관식 문제',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: SplashScreen_Loading())
          : writtenQuestions.isEmpty
          ? Center(
        child: Text(
          '생성된 자료가 없습니다.',
          style: TextStyle(fontSize: 18.0),
        ),
      )
          : ListView.builder(
        itemCount: writtenQuestions.length,
        itemBuilder: (context, index) {
          var question = writtenQuestions[index];
          return ListTile(
            title: Text(question['writtenTitle']),
            subtitle: Text('생성 날짜 : ${question['writtenCreated'].join('-')}'),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectiveQuestionDetailPage(
                      documentId: widget.documentId, writtenId: question['writtenId']),
                ),
              );
              if (result == true) {
                fetchWrittenQuestions(); // 리스트 다시 로드
              }
            },
          );
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }
}