import 'student.dart';

class Module {
  int id;
  String name;
  List<Student> students;

  Module({
    required this.id,
    required this.name,
    required this.students,
  });

  double getOverallAttendancePercentage() {
    if (students.isEmpty) return 0.0;

    double totalPercentage = 0;
    int studentCount = 0;

    for (var student in students) {
      totalPercentage += student.getAttendancePercentage();
      studentCount++;
    }

    if (studentCount == 0) return 0.0;
    return totalPercentage / studentCount;
  }
}