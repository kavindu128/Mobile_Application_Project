import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Management',
      theme: ThemeData(
        useMaterial3: true, // Enables modern Material 3 design
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF667eea),
          brightness: Brightness.light,
          primary: Color(0xFF667eea),
          secondary: Color(0xFF764ba2),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF667eea),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}