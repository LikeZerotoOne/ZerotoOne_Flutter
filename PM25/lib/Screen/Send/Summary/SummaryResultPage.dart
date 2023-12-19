import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Screen/SplashScreen_AI.dart';

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
      appBar: AppBar(
        title: Text(
          '자료 생성 - 문단 요약',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? SplashScreen_AI()
          : ListView.builder(
        itemCount: contexts.length + 2, // 추가된 두 버튼을 포함
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
                  maxLines: null,  // null로 설정하면 자동으로 여러 줄 표시됨
                  textAlign: TextAlign.start,  // 텍스트 정렬 설정 (start는 왼쪽 정렬)
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
                Divider(), // 간격을 추가하는 Divider 위젯
              ],
            );
          } else if (index == contexts.length) {
            return SizedBox(height: 16); // 간격을 추가하는 SizedBox 위젯
          } else {
            return Column(
              children: [
                SizedBox(height: 16), // 간격을 추가하는 SizedBox 위젯
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MakeQuestionPage(documentId: widget.documentId),
                        ),
                      );
                    },
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
                    child: Text('확인'),
                  ),
                ),
                SizedBox(height: 16), // 간격을 추가하는 SizedBox 위젯
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: _deleteSummaryResults,
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
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }

}
