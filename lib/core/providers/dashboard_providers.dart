import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'students_providers.dart';
import 'teachers_providers.dart';
import 'visits_providers.dart';
import '../models/visit.dart';

class DashboardStats {
  final int studentsCount;
  final int teachersCount;
  final int todayVisitsCount;
  final double attendanceRate;

  const DashboardStats({
    required this.studentsCount,
    required this.teachersCount,
    required this.todayVisitsCount,
    required this.attendanceRate,
  });
}

/// يجمّع إحصائيات لوحة التحكم من عدة مصادر بيانات حية (بدل الأرقام الثابتة سابقًا)
final dashboardStatsProvider = Provider<AsyncValue<DashboardStats>>((ref) {
  final students = ref.watch(studentsStreamProvider);
  final teachers = ref.watch(teachersStreamProvider);
  final visits = ref.watch(visitsStreamProvider);

  if (students.isLoading || teachers.isLoading || visits.isLoading) {
    return const AsyncValue.loading();
  }
  if (students.hasError) return AsyncValue.error(students.error!, students.stackTrace!);
  if (teachers.hasError) return AsyncValue.error(teachers.error!, teachers.stackTrace!);
  if (visits.hasError) return AsyncValue.error(visits.error!, visits.stackTrace!);

  final studentsList = students.value ?? [];
  final teachersList = teachers.value ?? [];
  final visitsList = visits.value ?? [];

  final now = DateTime.now();
  final todayVisits = visitsList.where((v) =>
      v.dateTime.year == now.year &&
      v.dateTime.month == now.month &&
      v.dateTime.day == now.day &&
      v.status != VisitStatus.cancelled);

  final present = studentsList.where((s) => s.status == 'منتظم').length;
  final attendanceRate =
      studentsList.isEmpty ? 0.0 : (present / studentsList.length) * 100;

  return AsyncValue.data(DashboardStats(
    studentsCount: studentsList.length,
    teachersCount: teachersList.length,
    todayVisitsCount: todayVisits.length,
    attendanceRate: attendanceRate,
  ));
});
