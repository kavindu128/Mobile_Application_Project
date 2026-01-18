import 'package:flutter/material.dart';
import '../models/module.dart';
import 'mark_attendance_page2.dart';

class MarkAttendancePage1 extends StatefulWidget {
  final Module module;
  MarkAttendancePage1({required this.module});
  @override
  _MarkAttendancePage1State createState() => _MarkAttendancePage1State();
}

class _MarkAttendancePage1State extends State<MarkAttendancePage1> {
  DateTime selectedDate = DateTime.now();
  int selectedHours = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Session Details')),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Step 1 of 2', style: TextStyle(color: Colors.grey)),
            Text('Session Info', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),

            // Date Picker Card
            InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF667eea)),
                ),
                child: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
              ),
            ),

            SizedBox(height: 25),

            // Dropdown
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Duration',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.timer, color: Color(0xFF667eea)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedHours,
                  isExpanded: true,
                  items: [1, 2, 3, 4].map((hours) {
                    return DropdownMenuItem(
                      value: hours,
                      child: Text('$hours hour${hours > 1 ? 's' : ''}'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedHours = value!),
                ),
              ),
            ),

            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarkAttendancePage2(
                      module: widget.module,
                      date: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      hours: selectedHours,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Next Step'), SizedBox(width: 10), Icon(Icons.arrow_forward)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}