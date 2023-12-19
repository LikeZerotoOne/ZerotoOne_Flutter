import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';


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
        title: Text(
          '나의 공부내역 - 키워드',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: SplashScreen_Loading())
          : keywords.isEmpty
          ? Center(
        child: Text(
          '생성된 자료가 없습니다.',
          style: TextStyle(fontSize: 18.0),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: keywords.map((keyword) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          keyword['keyword'],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          keyword['description'],
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          if (keywords.isNotEmpty) // 키워드가 있을 때만 버튼을 표시
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: deleteKeywords,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      onPrimary: Colors.black,
                      fixedSize:
                      Size(0.8 * MediaQuery.of(context).size.width, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Color(0xFFC3EAF4),
                          width: 4.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '삭제',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }
}
