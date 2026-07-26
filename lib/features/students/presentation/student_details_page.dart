import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/student.dart';
import '../../../core/providers/students_providers.dart';
import 'student_form_dialog.dart';

/// صفحة تفاصيل الطالب — لم تكن موجودة ضمن الأكواد المرسلة، أُنشئت هنا
/// لإكمال التنقّل من زر "عرض" في صفحة إدارة الطلاب.
class StudentDetailsPage extends ConsumerWidget {
  final String? studentId;
  const StudentDetailsPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (studentId == null) {
      return const Scaffold(
        body: Center(child: Text('معرّف الطالب غير صالح')),
      );
    }

    final studentsAsync = ref.watch(studentsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ملف الطالب')),
      body: studentsAsync.when(
        data: (students) {
          final student = students.where((s) => s.id == studentId).toList();
          if (student.isEmpty) {
            return const Center(child: Text('لم يتم العثور على الطالب'));
          }
          return _buildDetails(context, ref, student.first);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, WidgetRef ref, Student student) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(student.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _detailRow('الصف', student.className),
              _detailRow('الحالة', student.status),
              _detailRow('جوال ولي الأمر', student.guardianPhone ?? '—'),
              if (student.notes != null && student.notes!.isNotEmpty)
                _detailRow('ملاحظات', student.notes!),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('تعديل'),
                    onPressed: () async {
                      final result = await showDialog<Student>(
                        context: context,
                        builder: (_) => StudentFormDialog(existing: student),
                      );
                      if (result != null) {
                        await ref
                            .read(studentsServiceProvider)
                            .updateStudent(result);
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('حذف',
                        style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: Text('هل تريد حذف الطالب ${student.name}؟'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('حذف'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await ref
                            .read(studentsServiceProvider)
                            .deleteStudent(student.id);
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
