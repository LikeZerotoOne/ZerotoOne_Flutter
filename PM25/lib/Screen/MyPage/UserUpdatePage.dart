import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/LoginScreen.dart';
import 'package:pm25/Screen/MyPage/MyPage.dart';
import 'package:pm25/Storage/StorageUtil.dart';

class UserUpdatePage extends StatefulWidget {
  @override
  _UserUpdatePageState createState() => _UserUpdatePageState();
}
class _UserUpdatePageState extends State<UserUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
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
            // 사용자 이름 표시 및 기타 위젯들...
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => setState(() => _name = value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => setState(() => _email = value),
            ),
            ElevatedButton(
              onPressed: _updateUserInfo,
              child: Text('Update Info'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0,),
    );
  }
  void _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      final apiService = APIService();
      final statusCode = await apiService.updateUser(_name, _email);

      if (statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('성공했습니다')),

        );
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage()));

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('실패했습니다')),
        );
      }
    }
  }
}