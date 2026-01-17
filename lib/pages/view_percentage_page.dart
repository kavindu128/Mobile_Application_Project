import 'package:flutter/material.dart';
import 'package:mobile_application/data/app_date.dart';
import '../models/module.dart';
import '../models/student.dart';

class ViewPercentagePage extends StatefulWidget {
  final Module module;

  const ViewPercentagePage({super.key, required this.module});

  @override
  _ViewPercentagePageState createState() => _ViewPercentagePageState();
}

class _ViewPercentagePageState extends State<ViewPercentagePage> {
  void _showAddStudentDialog() {
    if (AppData.currentUser == null) {
      _showLoginDialog();
      return;
    }

    TextEditingController regController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: regController,
              decoration: InputDecoration(
                labelText: 'Registration Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (regController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                setState(() {
                  int newId = widget.module.students.isEmpty
                      ? 1
                      : widget.module.students
                              .map((s) => s.id)
                              .reduce((a, b) => a > b ? a : b) +
                          1;
                  widget.module.students.add(
                    Student(
                      id: newId,
                      regNo: regController.text,
                      name: nameController.text,
                      attendanceRecords: [],
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Student added successfully!')),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditStudentDialog(Student student) {
    if (AppData.currentUser == null) {
      _showLoginDialog();
      return;
    }

    TextEditingController regController =
        TextEditingController(text: student.regNo);
    TextEditingController nameController =
        TextEditingController(text: student.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: regController,
              decoration: InputDecoration(
                labelText: 'Registration Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                student.regNo = regController.text;
                student.name = nameController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Student updated successfully!')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteStudent(Student student) {
    if (AppData.currentUser == null) {
      _showLoginDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.module.students.remove(student);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Student deleted successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog() {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (usernameController.text == 'admin' &&
                  passwordController.text == 'admin') {
                setState(() {
                  AppData.currentUser = usernameController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login successful!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid credentials')),
                );
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Percentage'),
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
                double percentage = student.getAttendancePercentage();

                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
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
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667eea),
                        ),
                      ),
                      SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () => _showEditStudentDialog(student),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                        ),
                        child: Text('EDIT'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _deleteStudent(student),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                        ),
                        child: Text('DELETE'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _showAddStudentDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('ADD', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}