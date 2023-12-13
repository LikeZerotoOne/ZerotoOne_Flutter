import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';
import 'package:pm25/Storage/StorageUtil.dart';

class SendTextPage extends StatefulWidget {
  @override
  _SendTextPageState createState() => _SendTextPageState();
}

class _SendTextPageState extends State<SendTextPage> {
  final _formKey = GlobalKey<FormState>();
  String documentTitle = '';
  String text = '';
  int? documentId;

  void sendTextData() async {
    final memberId = await StorageUtil.getMemberId();
    var response = await APIService().postTextData(
      source: 'ko',
      target: 'en',
      text: text,
      memberId: memberId,
      documentTitle: documentTitle,
    );

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
    } else if (response.statusCode == 500) {
      // 네트워크 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류입니다. 재시도 해주세요.')),
      );
    }else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Text')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Document Title'),
                onChanged: (value) => documentTitle = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Text'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => text = value,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendTextData();
                  }
                },
                child: Text('전송'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 1,),

    );
  }
}