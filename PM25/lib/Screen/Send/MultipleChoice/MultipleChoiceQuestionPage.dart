import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';

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
      appBar: AppBar(title: Text('Multiple Choice Questions')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return buildQuestion(questions[index]);
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => showAnswers = !showAnswers),
        child: Text(showAnswers ? '답자 가리기' : '답지 보기'), // 아이콘 대신 텍스트 사용
        backgroundColor: Theme.of(context).primaryColor, // 버튼 배경색 지정
      ),
    );
  }

  Widget buildQuestion(Question question) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              question.title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
}
class Question {
  String title;
  List<Choice> multipleChoices;

  Question({required this.title, required this.multipleChoices});

  factory Question.fromJson(Map<String, dynamic> json) {
    var choicesJson = json['multipleChoices'] as List;
    List<Choice> choices = choicesJson.map((choiceJson) => Choice.fromJson(choiceJson)).toList();
    return Question(title: json['title'], multipleChoices: choices);
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
