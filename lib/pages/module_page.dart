import 'package:flutter/material.dart';
import '../models/module.dart';
import '../models/student.dart';
import '../data/app_data.dart';
import '../services/firestore_service.dart';
import 'mark_attendance_page1.dart';
import 'view_percentage_page.dart';

class ModulePage extends StatefulWidget {
  final Module module;

  ModulePage({required this.module});

  @override
  _ModulePageState createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showLoginDialog(BuildContext context) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MarkAttendancePage1(module: widget.module),
                  ),
                );
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
    return StreamBuilder<List<Student>>(
      stream: _firestoreService.getStudents(widget.module.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.module.name), backgroundColor: Color(0xFF667eea)),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Update module students to calculate percentage
        widget.module.students = snapshot.data!;
        double overallPercentage = widget.module.getOverallAttendancePercentage();

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.module.name, style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Color(0xFF667eea),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Top Section with Percentage Circle
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: Color(0xFF667eea),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              value: overallPercentage / 100,
                              strokeWidth: 10,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '${overallPercentage.toStringAsFixed(0)}%',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Attendance',
                                style: TextStyle(color: Colors.white70),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Menu Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildMenuButton(
                        context: context,
                        title: 'Mark Attendance',
                        subtitle: 'Record new session',
                        icon: Icons.add_task,
                        color: Colors.orange,
                        onTap: () {
                          if (AppData.currentUser == null) {
                            _showLoginDialog(context);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MarkAttendancePage1(module: widget.module),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      _buildMenuButton(
                        context: context,
                        title: 'View Analytics',
                        subtitle: 'Check student percentages',
                        icon: Icons.analytics,
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewPercentagePage(module: widget.module),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}