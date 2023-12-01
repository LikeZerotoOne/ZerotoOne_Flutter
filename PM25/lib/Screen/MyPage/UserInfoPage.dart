import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/LoginScreen.dart';
import 'package:pm25/Storage/StorageUtil.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool _isLoading = true;
  String username = '';
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    final apiService = APIService();
    final memberId = await StorageUtil.getMemberId(); // SharedPreferences에서 memberId 가져오기
    final response = await apiService.getUserDetails(memberId);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        username = data['username'];
        name = data['name'];
        email = data['email'];
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
      return Scaffold(
        appBar: AppBar(title: Text("회원정보 조회")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("회원정보 조회")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Username: $username'),
            Text('Name: $name'),
            Text('Email: $email'),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 0,),

    );
  }
}
