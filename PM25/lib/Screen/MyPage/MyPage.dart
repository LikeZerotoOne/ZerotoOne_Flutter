import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Screen/MyPage/UserInfoPage.dart';
import 'package:pm25/Screen/MyPage/UserUpdatePage.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final APIService _apiService = APIService();
  final _formKey = GlobalKey<FormState>();
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

  Widget buildGreeting() {
    return Container(
      width: double.infinity, // 가로로 꽉 차게 설정
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white60,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Transform.translate(
                    offset: Offset(-30, -10),
                    child: SvgPicture.asset(
                      'assets/imgs/AI_wink.svg',
                      width: 100,
                      height: 80,
                    ),
                  ),
                ),
                TextSpan(
                  text: '안녕하세요  ',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                TextSpan(
                  text: mypage_name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '  님!',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Route _customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        // 책 넘기듯이 위에서 아래로 페이드인하는 애니메이션 추가
        var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SplashScreen_Loading();
    }
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFFFFFFFF),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                buildGreeting(),
                SizedBox(height: 40),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(_customPageRoute(UserUpdatePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFC3EAF4),
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5.0,
                      ),
                      child: const Text(
                        '회원정보 수정',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(_customPageRoute(UserInfoPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFC3EAF4),
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5.0,
                      ),
                      child: const Text(
                        '회원정보 조회',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _apiService.logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFFFFFF),
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: Color(0xFF226FA9),
                            width: 4.0,
                          ),
                        ),
                        elevation: 5.0,
                      ),
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 3),
    );
  }
}