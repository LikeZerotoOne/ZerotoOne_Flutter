class Schedule {
  final int scheduleId;
  final String scheduleTitle;
  final String scheduleContent;
  final DateTime? scheduleDate; // DateTime 타입을 nullable로 변경

  Schedule({
    required this.scheduleId,
    required this.scheduleTitle,
    required this.scheduleContent,
    this.scheduleDate, // 생성자에서 nullable로 변경
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['scheduleDate'] is List) {
      List<dynamic> dateList = json['scheduleDate'];
      if (dateList.length == 3) {
        int year = dateList[0];
        int month = dateList[1];
        int day = dateList[2];
        parsedDate = DateTime(year, month, day);
      }
    }
    print("Parsed Content: ${json['scheduleContent'] ?? 'No Content Found'}");


    return Schedule(
      scheduleId: json['scheduleId'],
      scheduleTitle: json['scheduleTitle'] ?? '',
      scheduleContent: json['scheduleContent'] ?? '',
      scheduleDate: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'scheduleTitle': scheduleTitle,
      'scheduleContent': scheduleContent,
      'scheduleDate': scheduleDate?.toIso8601String(), // null-safe 호출
    };
  }
}