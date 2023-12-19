import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/StudyLog/DocumentDetailsPage.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'dart:convert';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class StudyLogPage extends StatefulWidget {
  @override
  _StudyLogPageState createState() => _StudyLogPageState();
}

class _StudyLogPageState extends State<StudyLogPage> {
  List<dynamic> documents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  void _fetchDocuments() async {
    final memberId = await StorageUtil.getMemberId();
    var response = await APIService().fetchDocuments(memberId);
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));

      setState(() {
        documents = data['documents'];
        isLoading = false;
      });
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문서 로딩에 실패했습니다')),
      );
    }
  }

  void deleteDocument(int documentId) async {
    var response = await APIService().deleteDocument(documentId);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문서가 삭제되었습니다')),
      );
      _fetchDocuments(); // 문서 목록을 다시 가져옴
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문서 삭제를 실패했습니다.')),
      );    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isLoading) SplashScreen_Loading(),
          if (!isLoading)
            Column(
              children: [
                AppBar(
                  title: Text(
                    '나의 공부내역',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Color(0xFFFFFFFF),
                  iconTheme: IconThemeData(color: Colors.black),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var document = documents[index];
                      var documentCreated = DateTime(
                        document['documentCreated'][0],
                        document['documentCreated'][1],
                        document['documentCreated'][2],
                      );
                      String formattedDate = DateFormat('yyyy-MM-dd').format(
                          documentCreated); // 날짜 포맷 변경

                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DocumentDetailsPage(documentId: document['documentId']),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              // 버튼이 눌린 상태일 때 색상 변경
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.grey; // 원하는 색상으로 변경 가능
                              }
                              // 기본 색상 반환
                              return Colors.white;
                            },
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            document['documentTitle'],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '생성일자 : $formattedDate',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteDocument(document['documentId']),
                          ),
                        ),
                      );

                    },
                  ),
                ),
                CommonBottomNavigationBar(selectedIndex: 0),
              ],
            ),
        ],
      ),
    );
  }
}
