import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class StudentsService {
  final CollectionReference<Map<String, dynamic>> _collection;

  StudentsService({FirebaseFirestore? firestore})
      : _collection =
            (firestore ?? FirebaseFirestore.instance).collection('students');

  Stream<List<Student>> watchStudents() {
    return _collection.orderBy('name').snapshots().map(
          (snap) => snap.docs
              .map((d) => Student.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Future<Student?> getStudent(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Student.fromMap(doc.id, doc.data()!);
  }

  Future<void> addStudent(Student student) {
    return _collection.add(student.toMap());
  }

  Future<void> updateStudent(Student student) {
    return _collection.doc(student.id).update(student.toMap());
  }

  Future<void> deleteStudent(String id) {
    return _collection.doc(id).delete();
  }
}
