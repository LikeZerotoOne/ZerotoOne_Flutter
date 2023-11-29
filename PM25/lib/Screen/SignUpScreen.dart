import 'package:flutter/material.dart';
import 'package:pm25/Validation/EmailValidator.dart';
import 'package:pm25/Validation/UsernameChecker.dart';
import '../API/APIService.dart';
import '../Model/UserModel.dart';

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

  String _sex = '남'; // 라디오 버튼의 상태를 관리하는 변수

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
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _usernameChecker.checkUsername(
                        _usernameController.text, context),
                    child: Text('중복 확인'),
                  ),
                ],
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),

              ElevatedButton(
                onPressed: _signUp,
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
