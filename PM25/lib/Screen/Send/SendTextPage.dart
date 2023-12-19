import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class SendTextPage extends StatefulWidget {
  @override
  _SendTextPageState createState() => _SendTextPageState();
}

class _SendTextPageState extends State<SendTextPage> {
  final _formKey = GlobalKey<FormState>();
  String documentTitle = '';
  String text = '';
  int? documentId;
  bool isLoading = false; // 추가된 부분

  void sendTextData() async {
    setState(() {
      isLoading = true; // 통신 시작 시 isLoading을 true로 설정하여 로딩 표시
    });

    final memberId = await StorageUtil.getMemberId();
    var response = await APIService().postTextData(
      source: 'ko',
      target: 'en',
      text: text,
      memberId: memberId,
      documentTitle: documentTitle,
    );

    setState(() {
      isLoading = false; // 통신 종료 시 isLoading을 false로 설정하여 로딩 표시 해제
    });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      documentId = responseData['documentId'];
      print(documentId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MakeQuestionPage(documentId: documentId!),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자료 생성',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '제목',
                  hintText: '제목을 입력해주세요',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFF226FA9),
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFF226FA9),
                      width: 3.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => documentTitle = value,
              ),
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '텍스트',
                  hintText: '텍스트를 입력해주세요',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFF226FA9),
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFF226FA9),
                      width: 3.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => text = value,
                maxLines: null, // 여러 줄 입력 가능
                minLines: 10, // 초기에 8줄을 보이도록 설정
              ),
              SizedBox(height: 40),
              Text(
                '이 자료를 AI에게 제공할까요?',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendTextData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      onPrimary: Colors.black,
                      minimumSize: Size(0.4 * MediaQuery.of(context).size.width, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Color(0xFFC3EAF4),
                          width: 4.0,
                        ),
                      ),
                    ),
                    child: isLoading
                        ? SplashScreen_Loading()
                        : Text(
                      '전송',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}
