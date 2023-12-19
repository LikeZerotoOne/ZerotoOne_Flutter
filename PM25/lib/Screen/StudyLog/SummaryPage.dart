import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

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
        title: Text(
          '나의 공부내역 - 문단 요약',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? SplashScreen_Loading()
          : contexts.isEmpty
          ? Center(
        child: Text(
          '생성된 자료가 없습니다.',
          style: TextStyle(fontSize: 18.0),
        ),
      )
          : ListView.builder(
        itemCount: contexts.length + 1, // 추가된 버튼을 포함
        itemBuilder: (context, index) {
          if (index < contexts.length) {
            var contextItem = contexts[index];
            return Column(
              children: [
                SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '원본',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  readOnly: true,
                  initialValue: contextItem['content'],
                  maxLines: null,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '요약본',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  readOnly: true,
                  initialValue: contextItem['summary'],
                  maxLines: null,
                  textAlign: TextAlign.start,
                ),
                Divider(),
              ],
            );
          } else {
            return Column(
              children: [
                SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: deleteSummary,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      onPrimary: Colors.black,
                      minimumSize: Size(0.8 * MediaQuery.of(context).size.width, 60),
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
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }
}
