import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/Screen/CalendarPage.dart';
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
          SnackBar(content: Text('Schedule added successfully')),

        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CalendarPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add schedule')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Schedule'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Schedule Title'),
                onChanged: (value) => setState(() => _scheduleTitle = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter schedule title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Schedule Content'),
                onChanged: (value) => setState(() => _scheduleContent = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter schedule content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitSchedule,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}