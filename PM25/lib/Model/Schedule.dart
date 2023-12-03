class Schedule {
  final int scheduleId;
  final String scheduleTitle;
  final String scheduleContent;

  Schedule({
    required this.scheduleId,
    required this.scheduleTitle,
    required this.scheduleContent,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      scheduleTitle: json['scheduleTitle'] ?? '', // Null 처리
      scheduleContent: json['scheduleContent'] ?? '', // Null 처리
    );
  }
}
