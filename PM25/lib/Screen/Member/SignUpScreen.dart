import 'package:flutter/material.dart';
import 'package:pm25/Validation/EmailValidator.dart';
import 'package:pm25/Validation/UsernameChecker.dart';
import '../../API/APIService.dart';
import '../../Model/UserModel.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _apiService = APIService();
  late UsernameChecker _usernameChecker; // UsernameChecker 인스턴스를 추가합니다.


  @override
  void initState() {
    super.initState();
    _usernameChecker = UsernameChecker(_apiService); // UsernameChecker를 초기화합니다.
  }

  // SignUpScreen.dart에서 회원가입 성공 후 로그인 페이지로 이동하는 코드

  Future<void> _signUp() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final email = _emailController.text;
    final EmailValidator _emailValidator = EmailValidator();

    // 이메일 형식 검증 추가
    if (!_emailValidator.isValidEmail(email)) {
      // 이메일 주소의 형식이 올바르지 않으면 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('올바른 이메일 주소를 입력해주세요.')),
      );
      return;
    }

    final user = User(
      username: username,
      password: password,
      name: name,
      email: email,

    );

    final response = await _apiService.signUp(user);

    if (response.statusCode == 200) {
      // 회원가입 성공 시 로그인 페이지로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('성공했습니다. 로그인 페이지로 이동합니다.')),
      );
      Navigator.of(context).pushReplacementNamed('/LoginScreen'); // 로그인 페이지로 이동
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('실패했습니다')),
      );
    }
  }

  @override
    Widget build(BuildContext context) {
      double textFieldWidth = MediaQuery
          .of(context)
          .size
          .width * 0.7;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            '회원가입',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 이 부분을 추가하여 왼쪽 정렬
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: '아이디: ',
                          hintText: '아이디를 입력하세요',
                          prefixIcon: Icon(Icons.person_4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () =>
                          _usernameChecker.checkUsername(_usernameController.text, context),
                      child: Text('중복 확인'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF226FA9),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(60, 60), // 버튼의 최소 크기를 설정
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호: ',
                      hintText: '비밀번호를 입력하세요',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름: ',
                      hintText: '이름을 입력하세요',
                      prefixIcon: Icon(Icons.person_2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: '이메일: ',
                      hintText: '이메일을 입력하세요',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7, // 원하는 너비로 설정
                      child: ElevatedButton(
                        onPressed: _signUp,
                        child: Text('가입하기'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF226FA9),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5.0,
                          minimumSize: Size(double.infinity, 50), // 최소 크기를 설정
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}