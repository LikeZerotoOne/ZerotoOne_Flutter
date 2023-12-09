import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';

class KeywordResultPage extends StatefulWidget {
  final int documentId;

  KeywordResultPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _KeywordResultPageState createState() => _KeywordResultPageState();
}

class _KeywordResultPageState extends State<KeywordResultPage> {
  late List<dynamic> keywords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    APIService().fetchKeywords(widget.documentId).then((keywords) {
      setState(() {
        this.keywords = keywords;
        isLoading = false;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('실패')),
      );    });
  }

  void _deleteKeywords() async {
    var response = await APIService().deleteKeywords(widget.documentId);
    if (response.statusCode == 200) {
      // 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 성공')),
      );

      // MakeQuestionPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MakeQuestionPage(documentId: widget.documentId),
        ),
      );
    } else {
      // 실패 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('취소 실패')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // 로딩 중일 때 로딩 인디케이터 표시
      return Scaffold(
        appBar: AppBar(title: Text('Keyword Results')),
        body: Center(child: CircularProgressIndicator()),
        bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
      );
    }

    // 로딩이 완료된 후 키워드 목록 표시
    return Scaffold(
      appBar: AppBar(title: Text('Keyword Results')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: keywords.length,
              itemBuilder: (context, index) {
                var keyword = keywords[index];
                return ListTile(
                  title: Text(keyword['keyword']),
                  subtitle: Text(keyword['description']),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MakeQuestionPage(documentId: widget.documentId),
                ),
              );
            },
            child: Text('확인'),
          ),
          ElevatedButton(
            onPressed: _deleteKeywords,
            child: Text('취소'),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}