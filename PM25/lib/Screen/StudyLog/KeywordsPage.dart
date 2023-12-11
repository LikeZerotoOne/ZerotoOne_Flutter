import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';

class KeywordsPage extends StatefulWidget {
  final int documentId;

  KeywordsPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _KeywordsPageState createState() => _KeywordsPageState();
}

class _KeywordsPageState extends State<KeywordsPage> {
  bool isLoading = true;
  List<dynamic> keywords = [];

  @override
  void initState() {
    super.initState();
    fetchKeywords();
  }

  void fetchKeywords() async {
    var response = await APIService().getKeywords(widget.documentId);
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        keywords = data['keywords'];
        isLoading = false;
      });
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('키워드 로딩 실패')),
      );
    }
  }
  void deleteKeywords() async {
    var response = await APIService().deleteKeywords(widget.documentId);
    if (response.statusCode == 200) {
      // 삭제 성공 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('키워드가 삭제되었습니다.')),
      );
      Navigator.pop(context); // 이전 페이지로 돌아가거나 필요한 처리
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('키워드 삭제 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keywords'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteKeywords();
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: keywords.length,
        itemBuilder: (context, index) {
          var keyword = keywords[index];
          return ListTile(
            title: Text(keyword['keyword']),
            subtitle: Text(keyword['description']),
          );
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),

    );
  }
}
