import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';

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
        title: Text('Multiple Choice Detail'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(question,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            child: Text(showAnswer ? '답지 숨기기' : '답지 보기'),
          ),
          ElevatedButton(
            onPressed: deleteMultipleChoiceQuestion,
            child: Text('삭제'),
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
        ],
      ),
    );
  }


}
