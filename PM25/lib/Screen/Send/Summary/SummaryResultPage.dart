import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';

class SummaryResultPage extends StatefulWidget {
  final int documentId;

  const SummaryResultPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _SummaryResultPageState createState() => _SummaryResultPageState();
}

class _SummaryResultPageState extends State<SummaryResultPage> {
  late List<dynamic> contexts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSummaryResults();
  }

  void _fetchSummaryResults() async {
    var response = await APIService().fetchSummaryResults(widget.documentId);
    if (response.statusCode == 200) {
      // utf8.decode를 사용하여 응답을 디코딩
      var decodedData = utf8.decode(response.bodyBytes);
      var data = json.decode(decodedData);
      setState(() {
        contexts = data['contexts'];
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문단 요약 결과를 가져오는 데 실패했습니다')),
      );
    }
  }

  void _deleteSummaryResults() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    var response = await APIService().deleteSummaryResults(widget.documentId);
    setState(() {
      isLoading = false; // 로딩 종료
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 성공')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MakeQuestionPage(documentId: widget.documentId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Summary Results')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: contexts.length + 2, // 추가된 두 버튼을 포함
        itemBuilder: (context, index) {
          if (index < contexts.length) {
            var contextItem = contexts[index];
            return ListTile(
              title: Text('원본: ${contextItem['content']}'),
              subtitle: Text('요약본: ${contextItem['summary']}'),
            );
          } else if (index == contexts.length) {
            return ElevatedButton(
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
            );
          } else {
            return ElevatedButton(
              onPressed: _deleteSummaryResults,
              child: Text('삭제'),
            );
          }
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),

    );
  }
}