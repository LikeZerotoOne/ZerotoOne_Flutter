import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Screen/SplashScreen_AI.dart';

class NewSubjectiveQuestionResultPage extends StatefulWidget {
  final int documentId;
  final List<int> writtenIds;

  NewSubjectiveQuestionResultPage({Key? key, required this.documentId, required this.writtenIds}) : super(key: key);

  @override
  _NewSubjectiveQuestionResultPageState createState() => _NewSubjectiveQuestionResultPageState();
}

class _NewSubjectiveQuestionResultPageState extends State<NewSubjectiveQuestionResultPage> {
  List<dynamic> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    var response = await APIService().getSubjectiveQuestions(
        widget.documentId, widget.writtenIds);
    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      var loadedQuestions = responseData
          .asMap()
          .entries
          .map((entry) {
        int index = entry.key;
        var data = entry.value;
        return {
          'question': data['question'],
          'title': data['title'],
          'answer': data['answer'],
          'writtenId': widget.writtenIds[index]
        };
      }).toList();

      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions')),
      );
    }
  }

  void deleteQuestion(int writtenId) async {
    var response = await APIService().deleteSubjectiveQuestion(
        widget.documentId, [writtenId]);
    if (response.statusCode == 200) {
      setState(() {
        widget.writtenIds.remove(writtenId);
        if (widget.writtenIds.isEmpty) {
          // 모든 주관식 문제가 삭제되었을 경우
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>
                MakeQuestionPage(documentId: widget.documentId)),
            ModalRoute.withName('/'),
          );
        } else {
          loadQuestions(); // 페이지 새로고침
        }
      });
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
        title: Text(
          '자료 생성 - 주관식 문제',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: SplashScreen_AI())
                : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                var question = questions[index];
                return ListTile(
                  title: Text('${index + 1}. ${question['question']}'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(question['title']),
                          content: Text(question['answer']),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteQuestion(question['writtenId']);
                              },
                            ),
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MakeQuestionPage(documentId: widget.documentId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFFFFF),
                onPrimary: Colors.black,
                minimumSize: Size(0.8 * MediaQuery
                    .of(context)
                    .size
                    .width, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Color(0xFFC3EAF4),
                    width: 4.0,
                  ),
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '터치하여 문제의 답을 확인해보세요!',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}