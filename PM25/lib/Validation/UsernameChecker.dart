import 'package:flutter/material.dart';

import '../API/APIService.dart';

class UsernameChecker {
  final APIService _apiService;

  UsernameChecker(this._apiService);

  Future<void> checkUsername(String username, BuildContext context) async {
    final response = await _apiService.checkUsernameDuplication(username);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용 가능 아이디입니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용 불가 아이디입니다.')),
      );
    }
  }
}
