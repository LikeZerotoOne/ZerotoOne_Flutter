import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pm25/API/APIService.dart';
import 'package:pm25/Model/Schedule.dart';
import 'package:pm25/NavigationBar/CommonBottomNavigationBar.dart';
import 'package:pm25/Screen/Calendar/AddScheduleForm.dart';
import 'package:pm25/Screen/Calendar/EditScheduleForm.dart';
import 'package:pm25/Screen/Member/LoginScreen.dart';
import 'package:pm25/Storage/StorageUtil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pm25/Screen/SplashScreen_Loading.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<DateTime> _markedDates;
  bool _isLoading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Schedule> _dailySchedules = [];

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

    final response = await apiService.getMonthlySchedules(memberId, year, month);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _markedDates = data.map((date) => DateTime(date[0], date[1], date[2])).toList();
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
        _dailySchedules = (data['data'] as List).map((e) => Schedule.fromJson(e)).toList();
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

  Future<Schedule> _fetchScheduleDetails(int scheduleId) async {
    final apiService = APIService();
    final response = await apiService.getScheduleDetails(scheduleId);
    if (response.statusCode == 200) {
      _isLoading = false;
      final decodedData = utf8.decode(response.bodyBytes);
      print("API Response: $decodedData");
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
      _fetchDailySchedules(_selectedDay ?? DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SplashScreen_Loading();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '캘린더',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: (day) {
              return _markedDates.where((date) => isSameDay(date, day)).toList();
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _fetchMonthlySchedules(_focusedDay.year, _focusedDay.month);
            },
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: _navigateToAddSchedule,
              child: Text('일정 추가하기'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF226FA9),
              ),
            ),
          ),
          Expanded(
            child: _dailySchedules.isEmpty
                ? Center(
              child: Text(
                "일정 추가하기 버튼을 눌러 일정을 추가해보세요!",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: _dailySchedules.length,
              itemBuilder: (context, index) {
                final schedule = _dailySchedules[index];
                return ExpansionTile(
                  title: Text(schedule.scheduleTitle),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FutureBuilder(
                        future: _fetchScheduleDetails(schedule.scheduleId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SplashScreen_Loading();
                          } else if (snapshot.hasData) {
                            final scheduleDetails = snapshot.data as Schedule;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('일정 내용: ${scheduleDetails.scheduleContent}'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        print("수정 양식으로 전달하는 내용: ${scheduleDetails.scheduleContent}");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditScheduleForm(
                                              scheduleId: schedule.scheduleId,
                                              initialTitle: schedule.scheduleTitle,
                                              initialContent: scheduleDetails.scheduleContent,
                                              selectedDay: _selectedDay ?? DateTime.now(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('수정'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF226FA9),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final responseCode = await APIService().deleteSchedule(schedule.scheduleId);
                                        if (responseCode == 200) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('일정이 삭제되었습니다')),
                                          );
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => CalendarPage()),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('일정이 삭제되지 않았습니다')),
                                          );
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                          );
                                        }
                                      },
                                      child: Text('삭제'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF226FA9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Text('정보 불러오기에 실패했습니다.');
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(selectedIndex: 2),
    );
  }
}
