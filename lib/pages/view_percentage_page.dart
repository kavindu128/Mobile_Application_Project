import 'package:flutter/material.dart';
import '../data/app_date.dart';
import '../models/module.dart';
import '../models/student.dart';
import '../data/app_data.dart';

class ViewPercentagePage extends StatefulWidget {
  final Module module;

  ViewPercentagePage({required this.module});

  @override
  _ViewPercentagePageState createState() => _ViewPercentagePageState();
}

class _ViewPercentagePageState extends State<ViewPercentagePage> {

  // --- RESTORED LOGIC: Login Dialog ---
  void _showLoginDialog() {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Login Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.lock),
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

  // --- RESTORED LOGIC: Add Student ---
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Add Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: regController,
              decoration: InputDecoration(
                labelText: 'Registration Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

  // --- RESTORED LOGIC: Edit Student ---
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Edit Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: regController,
              decoration: InputDecoration(
                labelText: 'Registration Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

  // --- RESTORED LOGIC: Delete Student ---
  void _deleteStudent(Student student) {
    if (AppData.currentUser == null) {
      _showLoginDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Analytics')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentDialog,
        backgroundColor: Color(0xFF667eea),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: widget.module.students.length,
        itemBuilder: (context, index) {
          Student student = widget.module.students[index];
          double percentage = student.getAttendancePercentage();
          Color statusColor = percentage >= 75
              ? Colors.green
              : (percentage >= 50 ? Colors.orange : Colors.red);

          return Card(
            margin: EdgeInsets.only(bottom: 15),
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text(student.regNo,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14)),
                        ],
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                              color: statusColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 8,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon:
                        Icon(Icons.edit, color: Colors.blueGrey, size: 20),
                        onPressed: () => _showEditStudentDialog(student),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: Colors.red[300], size: 20),
                        onPressed: () => _deleteStudent(student),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}