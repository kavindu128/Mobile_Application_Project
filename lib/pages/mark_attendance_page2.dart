import 'package:flutter/material.dart';
import '../models/module.dart';
import '../models/student.dart';
import '../models/attendance_record.dart';

class MarkAttendancePage2 extends StatefulWidget {
  final Module module;
  final String date;
  final int hours;

  MarkAttendancePage2({required this.module, required this.date, required this.hours});

  @override
  _MarkAttendancePage2State createState() => _MarkAttendancePage2State();
}

class _MarkAttendancePage2State extends State<MarkAttendancePage2> {
  Set<int> selectedStudents = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Students')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey),
                SizedBox(width: 10),
                Text('Tap to mark as Present', style: TextStyle(color: Colors.grey[700])),
                Spacer(),
                Text('${selectedStudents.length}/${widget.module.students.length}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF667eea))),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(15),
              itemCount: widget.module.students.length,
              separatorBuilder: (ctx, i) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                Student student = widget.module.students[index];
                bool isSelected = selectedStudents.contains(student.id);

                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) selectedStudents.remove(student.id);
                      else selectedStudents.add(student.id);
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white,
                      border: Border.all(
                          color: isSelected ? Colors.green : Colors.transparent,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 3)
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected ? Colors.green[100] : Colors.grey[200],
                        child: Text(
                          student.name[0],
                          style: TextStyle(
                              color: isSelected ? Colors.green[800] : Colors.grey[600],
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(student.regNo),
                      trailing: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Back'),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15)),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
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
                      Navigator.popUntil(context, (route) => route.isFirst);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Attendance Saved Successfully'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text('Finish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}