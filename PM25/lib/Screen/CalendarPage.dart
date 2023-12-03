import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/Model/Schedule.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/AddScheduleForm.dart';
import 'package:pm25/Screen/EditScheduleForm.dart';
import 'package:pm25/Screen/LoginScreen.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<DateTime> _markedDates;
  bool _isLoading = true;
  DateTime _focusedDay = DateTime.now(); // 현재 초점이 맞춰진 날짜
  DateTime? _selectedDay;
  List<Schedule> _dailySchedules = []; // 선택된 날짜의 일정 목록

  @override
  void initState() {
    super.initState();
    _fetchMonthlySchedules(_focusedDay.year, _focusedDay.month);
    _selectedDay = _focusedDay;
  }

  void _fetchMonthlySchedules(int year, int month) async {
    setState(() {
      _isLoading = true;
    });

    final apiService = APIService();
    final memberId = await StorageUtil.getMemberId();

    final response = await apiService.getMonthlySchedules(
        memberId, year, month);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _markedDates =
            data.map((date) => DateTime(date[0], date[1], date[2])).toList();
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _isLoading = true;
    });
    _fetchDailySchedules(selectedDay);
  }

  void _fetchDailySchedules(DateTime date) async {
    final apiService = APIService();
    final memberId = await StorageUtil.getMemberId();

    final response = await apiService.getDailySchedules(memberId, date);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        _dailySchedules = (data['data'] as List)
            .map((e) => Schedule.fromJson(e))
            .toList();
        _isLoading = false; // 데이터 로딩이 완료되면 _isLoading을 false로 설정
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
  Future<Schedule> _fetchScheduleDetails(int scheduleId) async {
    final apiService = APIService();
    final response = await apiService.getScheduleDetails(scheduleId);
    if (response.statusCode == 200) {
      _isLoading = false;
      final decodedData = utf8.decode(response.bodyBytes);
      print("API Response: $decodedData"); // API 응답 출력
      final data = json.decode(decodedData);
      return Schedule.fromJson(data);
    } else {
      throw Exception('Failed to load schedule details');
    }
  }
  void _navigateToAddSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddScheduleForm(selectedDay: _selectedDay ?? DateTime.now()),
      ),
    ).then((_) {
      // 양식에서 돌아온 후 필요한 경우 화면 갱신
      _fetchDailySchedules(_selectedDay ?? DateTime.now());
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: (day) {
              return _markedDates.where((date) => isSameDay(date, day))
                  .toList();
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _fetchMonthlySchedules(_focusedDay.year, _focusedDay.month);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dailySchedules.length,
              itemBuilder: (context, index) {
                final schedule = _dailySchedules[index];
                return ExpansionTile(
                  title: Text(schedule.scheduleTitle),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft, // 여기에 정렬을 추가
                        child: FutureBuilder(
                          future: _fetchScheduleDetails(schedule.scheduleId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              final scheduleDetails = snapshot.data as Schedule;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Content: ${scheduleDetails.scheduleContent}'),
                                  // 기타 상세 정보 표시...
                                  ElevatedButton(
                                    onPressed: () {
                                      print("Passing Content to Edit Form: ${scheduleDetails.scheduleContent}");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditScheduleForm(
                                            scheduleId: schedule.scheduleId,
                                            initialTitle: schedule.scheduleTitle,
                                            initialContent: scheduleDetails.scheduleContent, // 여기를 수정
                                            selectedDay: _selectedDay ?? DateTime.now(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text('수정'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final responseCode = await APIService().deleteSchedule(schedule.scheduleId);
                                      if (responseCode == 200) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Schedule deleted successfully')),
                                        );
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) => CalendarPage()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to delete schedule')),
                                        );
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) => LoginScreen()),
                                        );
                                      }
                                    },
                                    child: Text('삭제'),
                                  ),
                                ],
                              );
                            } else {
                              return Text('Failed to load details.');
                            }
                            },
                          ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSchedule, // 여기를 수정
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 2,),

    );
  }


}