import 'attendance_record.dart';

class Student {
  int id;
  String regNo;
  String name;
  List<AttendanceRecord> attendanceRecords;

  Student({
    required this.id,
    required this.regNo,
    required this.name,
    required this.attendanceRecords,
  });

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