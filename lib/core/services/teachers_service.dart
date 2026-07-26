import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher.dart';

class TeachersService {
  final CollectionReference<Map<String, dynamic>> _collection;

  TeachersService({FirebaseFirestore? firestore})
      : _collection =
            (firestore ?? FirebaseFirestore.instance).collection('teachers');

  Stream<List<Teacher>> watchTeachers() {
    return _collection.orderBy('name').snapshots().map(
          (snap) => snap.docs
              .map((d) => Teacher.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> addTeacher(Teacher teacher) {
    return _collection.add(teacher.toMap());
  }

  Future<void> updateTeacher(Teacher teacher) {
    return _collection.doc(teacher.id).update(teacher.toMap());
  }

  Future<void> deleteTeacher(String id) {
    return _collection.doc(id).delete();
  }
}
