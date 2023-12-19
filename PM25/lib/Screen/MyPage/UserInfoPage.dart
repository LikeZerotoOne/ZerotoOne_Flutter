import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';
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
  String real_name = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    final apiService = APIService();
    final memberId = await StorageUtil.getMemberId();
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
        body: Center(child: SplashScreen_Loading()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원정보 조회',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    '$name 님의 회원 정보',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                  ),
                ),
              ),
              SizedBox(height: 30),
              UserInfoItem(label: '아이디', value: username,),
              SizedBox(height: 20),
              UserInfoItem(label: '이름', value: name),
              SizedBox(height: 20),
              UserInfoItem(label: '이메일', value: email),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 3),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}