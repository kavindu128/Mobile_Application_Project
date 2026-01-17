import '../models/module.dart';
import '../models/student.dart';

class AppData {
  static String? currentUser;
  
  static List<Module> modules = [
    Module(
      id: 1,
      name: 'Mathematics',
      students: [
        Student(id: 1, regNo: 'EG/2022/5005', name: 'Munish S.', attendanceRecords: []),
        Student(id: 2, regNo: 'EG/2022/5006', name: 'John Doe', attendanceRecords: []),
        Student(id: 3, regNo: 'EG/2022/5007', name: 'Jane Smith', attendanceRecords: []),
      ],
    ),
    Module(
      id: 2,
      name: 'Physics',
      students: [
        Student(id: 1, regNo: 'EG/2022/5008', name: 'Alice Brown', attendanceRecords: []),
        Student(id: 2, regNo: 'EG/2022/5009', name: 'Bob Wilson', attendanceRecords: []),
      ],
    ),
    Module(
      id: 3,
      name: 'Chemistry',
      students: [
        Student(id: 1, regNo: 'EG/2022/5010', name: 'Charlie Davis', attendanceRecords: []),
        Student(id: 2, regNo: 'EG/2022/5011', name: 'Diana Evans', attendanceRecords: []),
      ],
    ),
  ];
}