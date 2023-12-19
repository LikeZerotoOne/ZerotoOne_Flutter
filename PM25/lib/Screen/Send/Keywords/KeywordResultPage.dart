import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Screen/SplashScreen_AI.dart';

class KeywordResultPage extends StatefulWidget {
  final int documentId;

  KeywordResultPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _KeywordResultPageState createState() => _KeywordResultPageState();
}

class _KeywordResultPageState extends State<KeywordResultPage> {
  late List<dynamic> keywords;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKeywords();
  }

  void _fetchKeywords() async {
    try {
      var fetchedKeywords = await APIService().fetchKeywords(widget.documentId);
      setState(() {
        keywords = fetchedKeywords;
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터를 불러오는데 실패했습니다')),
      );
    }
  }

  void _deleteKeywords() async {
    var response = await APIService().deleteKeywords(widget.documentId);
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
          '자료 생성 - 키워드',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: SplashScreen_AI())
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
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MakeQuestionPage(documentId: widget.documentId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFFFFF),
                    onPrimary: Colors.black,
                    fixedSize: Size(0.8 * MediaQuery.of(context).size.width, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: Color(0xFFC3EAF4),
                        width: 4.0,
                      ),
                    ),
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _deleteKeywords,
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFFFFF),
                    onPrimary: Colors.black,
                    fixedSize: Size(0.8 * MediaQuery.of(context).size.width, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: Color(0xFFC3EAF4),
                        width: 4.0,
                      ),
                    ),
                  ),
                  child: Text(
                    '취소',
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
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
  }