import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Send/MakeQuestionPage.dart';

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
        title: Text("Document Details"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Title: $documentTitle',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Content:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(koContent),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MakeQuestionPage(documentId: widget.documentId),
                    ),
                  );
                },
                child: Text('새 자료 생성하기'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0),
    );
  }
}