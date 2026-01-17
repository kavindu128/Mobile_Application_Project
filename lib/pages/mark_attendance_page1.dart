import 'package:flutter/material.dart';
import '../models/module.dart';
import 'mark_attendance_page2.dart';

class MarkAttendancePage1 extends StatefulWidget {
  final Module module;

  const MarkAttendancePage1({super.key, required this.module});

  @override
  _MarkAttendancePage1State createState() => _MarkAttendancePage1State();
}

class _MarkAttendancePage1State extends State<MarkAttendancePage1> {
  DateTime selectedDate = DateTime.now();
  int selectedHours = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        backgroundColor: Color(0xFF667eea),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Enter Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<int>(
                value: selectedHours,
                isExpanded: true,
                underline: SizedBox(),
                items: [1, 2, 3, 4]
                    .map((hours) => DropdownMenuItem(
                          value: hours,
                          child: Text('$hours hour${hours > 1 ? 's' : ''}'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedHours = value!;
                  });
                },
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarkAttendancePage2(
                        module: widget.module,
                        date:
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        hours: selectedHours,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF667eea),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}