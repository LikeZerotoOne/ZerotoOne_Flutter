import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';

class MultipleChoiceDetailPage extends StatefulWidget {
  final int documentId;
  final int multipleId;

  MultipleChoiceDetailPage({Key? key, required this.documentId, required this.multipleId}) : super(key: key);

  @override
  _MultipleChoiceDetailPageState createState() => _MultipleChoiceDetailPageState();
}

class _MultipleChoiceDetailPageState extends State<MultipleChoiceDetailPage> {
  bool isLoading = true;
  bool showAnswer = false;
  String question = '';
  List<dynamic> multipleChoices = [];

  @override
  void initState() {
    super.initState();
    fetchMultipleChoiceDetail();
  }

  void fetchMultipleChoiceDetail() async {
    var response = await APIService().getMultipleChoiceDetail(
        widget.documentId, widget.multipleId);
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        question = data['question'];
        multipleChoices = data['multipleChoices'];
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('객관식 문제 상세 정보 로딩 실패')),
      );
    }
  }

  void deleteMultipleChoiceQuestion() async {
    var response = await APIService().deleteMultipleChoice(
        widget.documentId, widget.multipleId);
    if (response.statusCode == 200) {
      Navigator.pop(context); // 이전 페이지로 돌아가기
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('객관식 문제 삭제 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 공부내역 - 객관식 문제',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: SplashScreen_Loading())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(question,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
            Divider(),
            ...multipleChoices.map((choice) =>
                ListTile(
                  title: Text(
                    '${choice['number']}. ${choice['content']}',
                    style: TextStyle(
                      color: showAnswer && choice['answer'] ? Colors.blue : null,
                    ),
                  ),
                )).toList(),
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
              child: Text(showAnswer ? '답지 숨기기' : '답지 보기'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: deleteMultipleChoiceQuestion,
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
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }
}
