class AttendanceRecord {
  String date;
  int hours;
  bool isPresent;

  AttendanceRecord({
    required this.date,
    required this.hours,
    required this.isPresent,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'hours': hours,
      'isPresent': isPresent,
    };
  }

  // Create from Map from Firebase
  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      date: map['date'] ?? '',
      hours: map['hours'] ?? 0,
      isPresent: map['isPresent'] ?? false,
    );
  }
}