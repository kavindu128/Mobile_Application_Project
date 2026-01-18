import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/module.dart';
import '../models/student.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get Modules Stream
  Stream<List<Module>> getModules() {
    return _db.collection('modules').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Module(
          id: doc.id,
          name: doc['name'],
          students: [], // Students fetched separately
        );
      }).toList();
    });
  }

  // Get Students for a specific Module
  Stream<List<Student>> getStudents(String moduleId) {
    return _db
        .collection('modules')
        .doc(moduleId)
        .collection('students')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Student.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Add Student
  Future<void> addStudent(String moduleId, Student student) async {
    await _db
        .collection('modules')
        .doc(moduleId)
        .collection('students')
        .add(student.toMap());
  }

  // Update Student (Mark Attendance)
  Future<void> updateStudent(String moduleId, Student student) async {
    await _db
        .collection('modules')
        .doc(moduleId)
        .collection('students')
        .doc(student.id)
        .update(student.toMap());
  }

  // Delete Student
  Future<void> deleteStudent(String moduleId, String studentId) async {
    await _db
        .collection('modules')
        .doc(moduleId)
        .collection('students')
        .doc(studentId)
        .delete();
  }

  // Helper to create initial modules if they don't exist
  Future<void> seedModules() async {
    List<String> subjects = ['Mathematics', 'Physics', 'Chemistry'];
    for (var subject in subjects) {
      var query = await _db.collection('modules').where('name', isEqualTo: subject).get();
      if (query.docs.isEmpty) {
        await _db.collection('modules').add({'name': subject});
      }
    }
  }
}