import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/StudyLog/MultipleChoiceDetailPage.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

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
        title: Text(
          '나의 공부내역 - 객관식 문제',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: SplashScreen_Loading())
          : multiples.isEmpty
          ? Center(
        child: Text(
          '생성된 자료가 없습니다.',
          style: TextStyle(fontSize: 18.0),
        ),
      )
          : ListView.builder(
        itemCount: multiples.length,
        itemBuilder: (context, index) {
          var multiple = multiples[index];
          return ListTile(
            title: Text(multiple['multipleTitle']),
            subtitle: Text('생성 날짜 : ${multiple['multipleCreated'].join('-')}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultipleChoiceDetailPage(
                    documentId: widget.documentId,
                    multipleId: multiple['multipleId'],
                  ),
                ),
              ).then((_) => fetchMultipleChoiceQuestions());
            },
          );
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }

}
