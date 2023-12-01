import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/HomeScreen.dart';
import 'package:pm25/Screen/LoginScreen.dart';
import 'package:pm25/Screen/MyPage/UserInfoPage.dart';
import 'package:pm25/Screen/MyPage/UserUpdatePage.dart';
import 'package:pm25/Storage/StorageUtil.dart';

class MyPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final APIService _apiService = APIService();
  final _formKey = GlobalKey<FormState>();
  String mypage_name='';
  bool _isLoading = true; // 로딩 상태 표시

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    final apiService = APIService();
    final memberId = await StorageUtil.getMemberId(); // SharedPreferences에서 memberId 가져오기
    final response = await apiService.getMyPageData(memberId);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        mypage_name = data['name']; // 사용자 이름 업데이트
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 필요')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("My Page"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text('Hello, $mypage_name'), // 사용자 이름 표시
            ElevatedButton(
              onPressed: () {
                // UserUpdatePage로 이동
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserUpdatePage()));
              },
              child: Text('회원정보 수정'),
            ),
            ElevatedButton(
              onPressed: () {
                // 추후 구현할 회원정보 조회 페이지로 이동
                // 현재는 더미 페이지로 이동하도록 설정
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserInfoPage()));
              },
              child: Text('회원정보 조회'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _apiService.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('로그아웃'),
            ),

          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0,),
    );
  }


}
