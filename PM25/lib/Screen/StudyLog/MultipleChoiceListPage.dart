import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/StudyLog/MultipleChoiceDetailPage.dart';

class MultipleChoiceListPage extends StatefulWidget {
  final int documentId;

  MultipleChoiceListPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _MultipleChoiceListPageState createState() => _MultipleChoiceListPageState();
}

class _MultipleChoiceListPageState extends State<MultipleChoiceListPage> {
  bool isLoading = true;
  List<dynamic> multiples = [];

  @override
  void initState() {
    super.initState();
    fetchMultipleChoiceQuestions();
  }

  void fetchMultipleChoiceQuestions() async {
    var response = await APIService().getMultipleChoice(widget.documentId);
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        multiples = data;
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('객관식 문제 로딩 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Choice Questions'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: multiples.length,
        itemBuilder: (context, index) {
          var multiple = multiples[index];
          return ListTile(
            title: Text(multiple['multipleTitle']),
            subtitle: Text('Created on: ${multiple['multipleCreated'].join('-')}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultipleChoiceDetailPage(
                    documentId: widget.documentId,
                    multipleId: multiple['multipleId'],
                  ),
                ),
              ).then((_) => fetchMultipleChoiceQuestions()); // 여기에 추가
            },
          );
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),

    );
  }
}
