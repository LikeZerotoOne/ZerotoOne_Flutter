import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Screen/Send/SendImagePage.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class ImageToTextResultPage extends StatefulWidget {
  final int documentId;

  ImageToTextResultPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _ImageToTextResultPageState createState() => _ImageToTextResultPageState();
}

class _ImageToTextResultPageState extends State<ImageToTextResultPage> {
  String documentTitle = '';
  String koContent = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDocumentDetails();
  }

  void _fetchDocumentDetails() async {
    var response = await APIService().getDocumentDetails(widget.documentId);
    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        documentTitle = responseData['documentTitle'];
        koContent = responseData['koContent'];
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('실패')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SplashScreen_Loading();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '문서 상세',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '제목: $documentTitle',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
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
                          builder: (context) =>
                              MakeQuestionPage(documentId: widget.documentId),
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
                      '확인',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var response = await APIService().deleteDocument(
                          widget.documentId);
                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('삭제 성공')),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              SendImagePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('삭제 실패')),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              LoginScreen()),
                        );
                      }
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
                      '삭제',
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
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1,),
    );
  }
}