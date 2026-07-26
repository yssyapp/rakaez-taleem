import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher.dart';
import '../services/teachers_service.dart';

final teachersServiceProvider = Provider<TeachersService>((ref) => TeachersService());

final teachersStreamProvider = StreamProvider<List<Teacher>>((ref) {
  return ref.watch(teachersServiceProvider).watchTeachers();
});
