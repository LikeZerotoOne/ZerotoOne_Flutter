import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';

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
        title: Text(title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            showAnswer
                ? Text(answer)
                : SizedBox.shrink(), // 답이 보이지 않을 때 빈 공간을 표시
            ElevatedButton(
              onPressed: () => setState(() => showAnswer = !showAnswer),
              child: Text(showAnswer ? '답 숨기기' : '답 보기'),
            ),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: deleteQuestion,
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),

    );
  }
}
