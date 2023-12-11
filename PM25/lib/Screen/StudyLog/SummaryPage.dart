import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';

class SummaryPage extends StatefulWidget {
  final int documentId;

  SummaryPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool isLoading = true;
  List<dynamic> contexts = [];

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  void fetchSummary() async {
    var response = await APIService().getSummary(widget.documentId);
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        contexts = data['contexts'];
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문단 요약 로딩 실패')),
      );
    }
  }
  void deleteSummary() async {
    var response = await APIService().deleteSummaryResults(widget.documentId);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문단 요약 삭제 성공')),
      );
      Navigator.of(context).pop(); // 이전 페이지로 이동
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문단 요약 삭제 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: contexts.length,
        itemBuilder: (context, index) {
          var contextItem = contexts[index];
          return ListTile(
            title: Text(contextItem['content']),
            subtitle: Text(contextItem['summary']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: deleteSummary,
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }
}
