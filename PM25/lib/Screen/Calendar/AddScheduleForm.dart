import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/Screen/Calendar/CalendarPage.dart';
import 'package:pm25/Storage/StorageUtil.dart';

class AddScheduleForm extends StatefulWidget {
  final DateTime selectedDay;

  AddScheduleForm({required this.selectedDay});

  @override
  _AddScheduleFormState createState() => _AddScheduleFormState();
}

class _AddScheduleFormState extends State<AddScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  String _scheduleTitle = '';
  String _scheduleContent = '';

  // 서버에 일정 추가 요청
  Future<void> _submitSchedule() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // 키보드 숨기기

      final apiService = APIService();
      final memberId = await StorageUtil.getMemberId();
      final scheduleDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

      final int response = await apiService.addSchedule(
          memberId, _scheduleTitle, _scheduleContent, scheduleDate);

      if (response == 200) {
        Navigator.pop(context); // 양식 창 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일정이 성공적으로 추가되었습니다.')),

        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CalendarPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일정을 추가하는데 실패했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '일정 추가하기',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 50),
                TextFormField(
                  decoration: InputDecoration(labelText: ' 일정 제목'),
                  onChanged: (value) => setState(() => _scheduleTitle = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '일정 제목을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '일정 내용',
                    border: OutlineInputBorder(), // 테두리 추가
                  ),
                  maxLines: null, // 여러 줄 입력 가능
                  keyboardType: TextInputType.multiline, // 여러 줄 입력을 위한 키보드 타입 설정
                  onChanged: (value) => setState(() => _scheduleContent = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '일정 내용을 입력해주세요';
                    }
                    return null;
                  },
                )
                ,SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submitSchedule,
                  child: Text('추가완료'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF226FA9),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(300, 60),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}