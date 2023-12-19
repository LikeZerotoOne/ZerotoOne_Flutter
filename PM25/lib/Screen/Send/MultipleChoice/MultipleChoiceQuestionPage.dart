import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Screen/SplashScreen_AI.dart';

class MultipleChoiceQuestionPage extends StatefulWidget {
  final int documentId;
  final List<int> multipleIds;

  MultipleChoiceQuestionPage({Key? key, required this.documentId, required this.multipleIds}) : super(key: key);

  @override
  _MultipleChoiceQuestionPageState createState() => _MultipleChoiceQuestionPageState();
}

class _MultipleChoiceQuestionPageState extends State<MultipleChoiceQuestionPage> {
  List<Question> questions = [];
  bool isLoading = true;
  bool showAnswers = false;
  List<int> selectedMultipleIds = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  void fetchQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await APIService().getMultipleChoiceQuestions(
          widget.documentId, widget.multipleIds);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<Question> fetchedQuestions = jsonResponse.map<Question>((json) =>
            Question.fromJson(json)).toList();

        setState(() {
          questions = fetchedQuestions;
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch questions')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자료 생성 - 객관식 문제 ',
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
                return buildQuestion(questions[index], widget.multipleIds[index]);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => showAnswers = !showAnswers),
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
                  child: Text(
                    showAnswers ? '답자 가리기' : '답지 보기',
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MakeQuestionPage(documentId: widget.documentId)),
                  ),
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
                  child: Text('확인'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: deleteSelectedQuestions,
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
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );


  }


  Widget buildQuestion(Question question, int multipleId) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: question.isSelected,
              onChanged: (bool? newValue) {
                setState(() {
                  question.isSelected = newValue ?? false;
                  if (question.isSelected) {
                    selectedMultipleIds.add(multipleId);
                  } else {
                    selectedMultipleIds.remove(multipleId);
                  }
                });
              },
            ),
            title: Text(
              question.title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(),
          ...question.multipleChoices.map((choice) =>
              ListTile(
                title: Text(
                  '${choice.number}. ${choice.content}',
                  style: TextStyle(
                    color: showAnswers && choice.answer
                        ? Colors.blue
                        : null, // 답이 맞을 때 파랑색으로 변경
                  ),
                ),
              )
          ).toList(),
        ],
      ),
    );
  }
  void deleteSelectedQuestions() async {
    // 선택된 문제 삭제 로직
    if (selectedMultipleIds.isEmpty) return;

    try {
      var response = await APIService().deleteMultipleChoiceQuestions(
          widget.documentId, selectedMultipleIds);
      if (response.statusCode == 200) {
        // 성공적으로 삭제됨
        if (selectedMultipleIds.length == widget.multipleIds.length) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MakeQuestionPage(documentId: widget.documentId)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MultipleChoiceQuestionPage(
                documentId: widget.documentId, multipleIds: widget.multipleIds.where((id) => !selectedMultipleIds.contains(id)).toList())),
          );
        }
      } else {
        // 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete questions')),
        );
      }
    } catch (e) {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

}

class Question {
  String title;
  List<Choice> multipleChoices;
  bool isSelected = false; // 체크박스 선택 상태를 나타내는 필드 추가

  Question({required this.title, required this.multipleChoices});

  factory Question.fromJson(Map<String, dynamic> json) {
    var choicesJson = json['multipleChoices'] as List;
    List<Choice> choices = choicesJson.map((choiceJson) => Choice.fromJson(choiceJson)).toList();
    return Question(title: json['question'], multipleChoices: choices);
  }
}

class Choice {
  String content;
  int number;
  bool answer;

  Choice({required this.content, required this.number, required this.answer});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      content: json['content'],
      number: json['number'],
      answer: json['answer'],
    );
  }
}
