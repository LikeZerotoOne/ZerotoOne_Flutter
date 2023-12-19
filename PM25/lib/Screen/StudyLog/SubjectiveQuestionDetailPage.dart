import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class SubjectiveQuestionDetailPage extends StatefulWidget {
  final int documentId;
  final int writtenId;

  SubjectiveQuestionDetailPage({Key? key, required this.documentId, required this.writtenId}) : super(key: key);

  @override
  _SubjectiveQuestionDetailPageState createState() => _SubjectiveQuestionDetailPageState();
}

class _SubjectiveQuestionDetailPageState extends State<SubjectiveQuestionDetailPage> {
  bool isLoading = true;
  bool showAnswer = false;
  String title = '';
  String question = '';
  String answer = '';

  @override
  void initState() {
    super.initState();
    fetchQuestionDetail();
  }

  void fetchQuestionDetail() async {
    var response = await APIService().getSubjectiveQuestionDetail(widget.documentId, widget.writtenId);
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        title = data['title'];
        question = data['question'];
        answer = data['answer'];
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load question detail')),
      );
    }
  }
  void deleteQuestion() async {
    var response = await APIService().deleteSubjective(widget.documentId, widget.writtenId);
    if (response.statusCode == 200) {
      Navigator.pop(context, true); // 삭제 성공 시 true 반환
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete question')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 공부내역 - 주관식 문제',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: SplashScreen_Loading())
          : Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              showAnswer ? Text(answer) : SizedBox.shrink(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() => showAnswer = !showAnswer),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFFFFF),
                  onPrimary: Colors.black,
                  fixedSize: Size(0.8 * MediaQuery.of(context).size.width, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: Color(0xFFC3EAF4),
                      width: 4.0,
                    ),
                  ),
                ),
                child: Text(showAnswer ? '답 숨기기' : '답 보기'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: deleteQuestion,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFFFFF),
                  onPrimary: Colors.black,
                  fixedSize: Size(0.8 * MediaQuery.of(context).size.width, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: Color(0xFFC3EAF4),
                      width: 4.0,
                    ),
                  ),
                ),
                child: Text('삭제'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }
}