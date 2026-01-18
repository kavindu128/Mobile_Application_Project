import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/module.dart';
import '../services/firestore_service.dart';
import 'module_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showLoginDialog() {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person)),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (usernameController.text == 'admin' && passwordController.text == 'admin') {
                setState(() {
                  AppData.currentUser = usernameController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful!')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials. Use admin/admin')));
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    setState(() {
      AppData.currentUser = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dashboard', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        Text('Modules', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    AppData.currentUser == null
                        ? IconButton(
                      onPressed: _showLoginDialog,
                      icon: Icon(Icons.login, color: Colors.white, size: 30),
                      tooltip: 'Login',
                    )
                        : Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: _logout,
                          icon: Icon(Icons.logout, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: StreamBuilder<List<Module>>(
                    stream: _firestoreService.getModules(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      
                      // Check if empty, allow seeding
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: ElevatedButton(
                            onPressed: () => _firestoreService.seedModules(),
                            child: Text("Initialize Default Modules"),
                          ),
                        );
                      }

                      final modules = snapshot.data!;

                      return GridView.builder(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: modules.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ModulePage(module: modules[index])),
                                ).then((_) => setState(() {}));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF667eea).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.book, size: 35, color: Color(0xFF667eea)),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    modules[index].name,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Tap to view',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}