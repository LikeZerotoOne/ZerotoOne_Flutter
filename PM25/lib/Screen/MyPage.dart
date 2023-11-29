import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/LoginScreen.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  String _name = '';
  String _email = '';
  bool _isLoading = true; // 로딩 상태 표시
  bool _isAuthenticated = false; // 인증 상태

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final apiService = APIService();
    _isAuthenticated = await apiService.isAuthenticated();

    setState(() {
      _isLoading = false;
    });

    if (!_isAuthenticated) {
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
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
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
    final apiService = APIService();

    // 먼저 사용자 인증 상태를 확인
    if (await apiService.isAuthenticated()) {
      // 인증 성공: 사용자 정보 업데이트 진행
      final statusCode = await apiService.updateUser(_password, _name, _email);

      if (statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('성공했습니다')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('실패했습니다')),
        );
      }
    } else {
      // 인증 실패: 사용자에게 알림 또는 로그인 페이지로 리다이렉트
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증 실패: 로그인이 필요합니다')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
