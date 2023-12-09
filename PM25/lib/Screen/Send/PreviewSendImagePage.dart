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

class PreviewSendImagePage extends StatefulWidget {
  final XFile image;

  PreviewSendImagePage({required this.image});

  @override
  _PreviewSendImagePageState createState() => _PreviewSendImagePageState();
}

class _PreviewSendImagePageState extends State<PreviewSendImagePage> {
  String documentTitle = '';
  bool isLoading = false;  // 로딩 상태를 추적하는 변수

  void _sendImage() async {
    setState(() {
      isLoading = true;  // 로딩 시작
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
      isLoading = false;  // 로딩 종료
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
        MaterialPageRoute(builder: (context) => ImageToTextResultPage(documentId: documentId)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('실패')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SendImagePage()),
      );    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview Image')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // 로딩 중인 경우
          : SingleChildScrollView(  // 로딩이 끝난 경우
        child: Column(
          children: <Widget>[
            Image.file(File(widget.image.path)),
            TextFormField(
              decoration: InputDecoration(labelText: 'Document Title'),
              onChanged: (value) => documentTitle = value,
            ),
            ElevatedButton(
              onPressed: _sendImage,
              child: Text('전송'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1),
    );
  }
}
