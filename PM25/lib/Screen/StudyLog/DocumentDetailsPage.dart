import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Screen/StudyLog/ExistingMaterialsPage.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class DocumentDetailsPage extends StatefulWidget {
  final int documentId;

  const DocumentDetailsPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _DocumentDetailsPageState createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends State<DocumentDetailsPage> {
  String documentTitle = '';
  String koContent = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDocumentDetails();
  }

  void _fetchDocumentDetails() async {
    var response = await APIService().fetchDocumentDetails(widget.documentId);
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        documentTitle = data['documentTitle'];
        koContent = data['koContent'];
        isLoading = false;
      });
    } else {
      // 오류 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        '문서 상세',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      iconTheme: IconThemeData(color: Colors.black),
    ),
      body: isLoading
          ? Center(child: SplashScreen_Loading())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '제목: $documentTitle',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,),
              ),
              SizedBox(height: 10),
              Text(
                '내용:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(koContent),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      minimumSize: Size(0.4 * MediaQuery
                          .of(context)
                          .size
                          .width, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Color(0xFFC3EAF4),
                          width: 4.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '새 자료 생성하기',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExistingMaterialsPage(documentId: widget.documentId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      onPrimary: Colors.black,
                      minimumSize: Size(0.4 * MediaQuery
                          .of(context)
                          .size
                          .width, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Color(0xFFC3EAF4),
                          width: 4.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '기존 자료 보기',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }
}