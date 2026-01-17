import 'package:flutter/material.dart';
import '../models/module.dart';
import '../models/student.dart';
import '../models/attendance_record.dart';

class MarkAttendancePage2 extends StatefulWidget {
  final Module module;
  final String date;
  final int hours;

  const MarkAttendancePage2({super.key, 
    required this.module,
    required this.date,
    required this.hours,
  });

  @override
  _MarkAttendancePage2State createState() => _MarkAttendancePage2State();
}

class _MarkAttendancePage2State extends State<MarkAttendancePage2> {
  Set<int> selectedStudents = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        backgroundColor: Color(0xFF667eea),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: widget.module.students.length,
              itemBuilder: (context, index) {
                Student student = widget.module.students[index];
                bool isSelected = selectedStudents.contains(student.id);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedStudents.remove(student.id);
                      } else {
                        selectedStudents.add(student.id);
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedStudents.add(student.id);
                              } else {
                                selectedStudents.remove(student.id);
                              }
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.regNo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF667eea),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                student.name,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('CANCEL', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    for (var student in widget.module.students) {
                      student.attendanceRecords.add(
                        AttendanceRecord(
                          date: widget.date,
                          hours: widget.hours,
                          isPresent: selectedStudents.contains(student.id),
                        ),
                      );
                    }

                    Navigator.popUntil(
                        context, (route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Attendance saved successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('SAVE', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}