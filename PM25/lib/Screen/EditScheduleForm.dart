import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/Model/Schedule.dart';
import 'package:pm25/Screen/CalendarPage.dart';

class EditScheduleForm extends StatefulWidget {
  final int scheduleId;
  final String initialTitle;
  final String initialContent;
  final DateTime selectedDay;

  EditScheduleForm({
    required this.scheduleId,
    required this.initialTitle,
    required this.initialContent,
    required this.selectedDay,
  });

  @override
  _EditScheduleFormState createState() => _EditScheduleFormState();
}

class _EditScheduleFormState extends State<EditScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);

    print("Initial Title: ${widget.initialTitle}"); // 제목 값 출력
    print("Initial Content: ${widget.initialContent}"); // 내용 값 출력
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitChanges() async {
    if (_formKey.currentState!.validate()) {
      final apiService = APIService();
      final scheduleDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

      final response = await apiService.updateSchedule(
          widget.scheduleId, _titleController.text, _contentController.text, scheduleDate);

      if (response == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Schedule updated successfully')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CalendarPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update schedule')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Schedule'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Schedule Title'),
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Schedule Content',
                  border: OutlineInputBorder(), // 테두리 추가
                ),
                maxLines: null, // 여러 줄 입력 가능
                keyboardType: TextInputType.multiline, // 여러 줄 입력을 위한 키보드 타입 설정
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter schedule content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitChanges,
                child: Text('수정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}