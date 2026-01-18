import 'attendance_record.dart';

class Student {
  String id; // Changed to String for Firebase
  String regNo;
  String name;
  List<AttendanceRecord> attendanceRecords;

  Student({
    required this.id,
    required this.regNo,
    required this.name,
    required this.attendanceRecords,
  });

  Map<String, dynamic> toMap() {
    return {
      'regNo': regNo,
      'name': name,
      'attendanceRecords': attendanceRecords.map((x) => x.toMap()).toList(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map, String docId) {
    return Student(
      id: docId,
      regNo: map['regNo'] ?? '',
      name: map['name'] ?? '',
      attendanceRecords: List<AttendanceRecord>.from(
        (map['attendanceRecords'] as List<dynamic>? ?? []).map<AttendanceRecord>(
          (x) => AttendanceRecord.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  double getAttendancePercentage() {
    if (attendanceRecords.isEmpty) return 0.0;

    int totalHours = 0;
    int attendedHours = 0;

    for (var record in attendanceRecords) {
      totalHours += record.hours;
      if (record.isPresent) {
        attendedHours += record.hours;
      }
    }

    if (totalHours == 0) return 0.0;
    return (attendedHours / totalHours) * 100;
  }
}