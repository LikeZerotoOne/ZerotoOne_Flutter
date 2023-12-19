import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/ImageToTextResultPage.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Screen/Send/SendImagePage.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class PreviewSendImagePage extends StatefulWidget {
  final XFile image;

  PreviewSendImagePage({required this.image});

  @override
  _PreviewSendImagePageState createState() => _PreviewSendImagePageState();
}

class _PreviewSendImagePageState extends State<PreviewSendImagePage> {
  String documentTitle = '';
  bool isLoading = false; // 로딩 상태를 추적하는 변수
  bool isTitleEmpty = true;

  void _sendImage() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });
    final memberId = await StorageUtil.getMemberId();
    var imageFile = File(widget.image.path); // 이미지 파일 가져오기

    var response = await APIService().sendImage(
      imageFile: imageFile,
      documentTitle: documentTitle,
      memberId: memberId,
    );

    // 로딩 상태 업데이트
    setState(() {
      isLoading = false; // 로딩 종료
    });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      int documentId = responseData['documentId'];

      // 성공 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('성공했습니다')),
      );

      // ImageToTextResultPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageToTextResultPage(documentId: documentId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('실패')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SendImagePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SplashScreen_Loading()
        : Scaffold(
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
            children: <Widget>[
              Image.file(File(widget.image.path)),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '문서 제목',
                  labelStyle: TextStyle(
                    color: isTitleEmpty ? Colors.grey : Colors.black,
                  ),
                  errorText: isTitleEmpty ? '제목을 입력해주세요' : null,
                ),
                onChanged: (value) {
                  setState(() {
                    documentTitle = value;
                    isTitleEmpty = value.isEmpty;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _sendImage,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      onPrimary: Colors.black,
                      minimumSize: Size(
                        0.4 * MediaQuery.of(context).size.width,
                        60,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Color(0xFFC3EAF4),
                          width: 4.0,
                        ),
                      ),
                    ),
                    child: Text('전송'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      onPrimary: Colors.black,
                      minimumSize: Size(
                        0.4 * MediaQuery.of(context).size.width,
                        60,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Color(0xFFC3EAF4),
                          width: 4.0,
                        ),
                      ),
                    ),
                    child: Text('취소'),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}