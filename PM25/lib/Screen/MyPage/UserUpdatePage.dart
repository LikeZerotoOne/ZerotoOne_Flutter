import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/MyPage/MyPage.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:pm25/Validation/EmailValidator.dart';

class UserUpdatePage extends StatefulWidget {
  @override
  _UserUpdatePageState createState() => _UserUpdatePageState();
}

class _UserUpdatePageState extends State<UserUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String mypage_name = '';
  bool _isLoading = true; // 로딩 상태 표시

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    final apiService = APIService();
    final memberId = await StorageUtil.getMemberId();
    final response = await apiService.getMyPageData(memberId);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        mypage_name = data['name'];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원 정보 수정',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15.0),
                Text(
                  '$mypage_name 님의 정보를 수정하세요.',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 70.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '이름 : ',
                    hintText: '이름을 입력해주세요.',
                    prefixIcon: Icon(Icons.person), // 왼쪽에 아이콘 추가
                    border: OutlineInputBorder( // 외곽선 스타일링
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true, // 배경 채우기
                    fillColor: Colors.white, // 배경 색상
                  ),
                  onChanged: (value) => setState(() => _name = value),
                ),

                SizedBox(height:30.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '이메일 : ',
                    hintText: '이메일을 입력해주세요.',
                    prefixIcon: Icon(Icons.email), // 왼쪽에 아이콘 추가
                    border: OutlineInputBorder( // 외곽선 스타일링
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true, // 배경 채우기
                    fillColor: Colors.white, // 배경 색상
                  ),
                  onChanged: (value) => setState(() => _email = value),
                  validator: (value) {
                    final validator = EmailValidator();
                    if (value == null || value.isEmpty || !validator.isValidEmail(value)) {
                      return '유효한 이메일 주소를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50.0),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateUserInfo();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF226FA9),
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5.0,
                      ),
                      child: const Text(
                        '수정 완료',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Text(
                  '수정하고 싶은 정보를 입력하고, 수정하지 않는다면 기존 정보를 유지합니다.',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 3),
    );
  }

  void _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      final apiService = APIService();
      final statusCode = await apiService.updateUser(_name, _email);

      if (statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('성공적으로 수정되었습니다.')),
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('수정에 실패했습니다.')),
        );
      }
    }
  }
}
