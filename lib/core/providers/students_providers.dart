import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../services/students_service.dart';

final studentsServiceProvider = Provider<StudentsService>((ref) => StudentsService());

final studentsStreamProvider = StreamProvider<List<Student>>((ref) {
  return ref.watch(studentsServiceProvider).watchStudents();
});
