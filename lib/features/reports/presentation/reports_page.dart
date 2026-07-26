import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/students_providers.dart';
import '../../../core/providers/teachers_providers.dart';
import '../../../core/providers/visits_providers.dart';
import '../../../core/models/visit.dart';

/// نظام التقارير الأساسي (ملخصات حية من البيانات).
/// تصدير PDF/Excel مؤجل لمرحلة لاحقة من الخطة — يحتاج مكتبة تصدير مخصصة
/// (مثل pdf أو syncfusion_flutter_xlsio) وتصميم قوالب تقارير منفصل.
class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsStreamProvider).value ?? [];
    final teachers = ref.watch(teachersStreamProvider).value ?? [];
    final visits = ref.watch(visitsStreamProvider).value ?? [];

    final presentCount = students.where((s) => s.status == 'منتظم').length;
    final absentCount = students.length - presentCount;
    final completedVisits =
        visits.where((v) => v.status == VisitStatus.completed).length;
    final cancelledVisits =
        visits.where((v) => v.status == VisitStatus.cancelled).length;

    return Scaffold(
      appBar: AppBar(title: const Text('التقارير')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _reportSection(
              title: 'تقرير الطلاب',
              rows: {
                'إجمالي الطلاب': '${students.length}',
                'منتظمون': '$presentCount',
                'متغيبون': '$absentCount',
              },
            ),
            const SizedBox(height: 16),
            _reportSection(
              title: 'تقرير المعلمين',
              rows: {'إجمالي المعلمين': '${teachers.length}'},
            ),
            const SizedBox(height: 16),
            _reportSection(
              title: 'تقرير الزيارات',
              rows: {
                'إجمالي الزيارات': '${visits.length}',
                'زيارات مكتملة': '$completedVisits',
                'زيارات ملغاة': '$cancelledVisits',
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('تصدير PDF / Excel (قريبًا)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportSection({
    required String title,
    required Map<String, String> rows,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ...rows.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key),
                    Text(e.value,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
