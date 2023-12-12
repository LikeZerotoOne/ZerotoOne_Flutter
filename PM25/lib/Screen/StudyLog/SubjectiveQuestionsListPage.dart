import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
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
        title: Text('Subjective Questions'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: writtenQuestions.length,
        itemBuilder: (context, index) {
          var question = writtenQuestions[index];
          return ListTile(
            title: Text(question['writtenTitle']),
            subtitle: Text('Created on: ${question['writtenCreated'].join('-')}'),onTap: () async {
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
