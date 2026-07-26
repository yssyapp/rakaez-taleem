import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/teacher.dart';
import '../../../core/providers/teachers_providers.dart';

class TeachersPage extends ConsumerWidget {
  const TeachersPage({super.key});

  Future<void> _openAddDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final subjectController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Teacher>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة معلم جديد'),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'اسم المعلم'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(labelText: 'المادة'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'رقم الجوال'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.of(context).pop(Teacher(
                id: '',
                name: nameController.text.trim(),
                subject: subjectController.text.trim(),
                phone: phoneController.text.trim(),
              ));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (result != null) {
      await ref.read(teachersServiceProvider).addTeacher(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersAsync = ref.watch(teachersStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المعلمين')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () => _openAddDialog(context, ref),
                child: const Text('إضافة معلم جديد'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: teachersAsync.when(
                data: (teachers) {
                  if (teachers.isEmpty) {
                    return const Center(child: Text('لا يوجد معلمون بعد'));
                  }
                  return Card(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('الاسم')),
                        DataColumn(label: Text('المادة')),
                        DataColumn(label: Text('الجوال')),
                        DataColumn(label: Text('')),
                      ],
                      rows: teachers.map((t) {
                        return DataRow(cells: [
                          DataCell(Text(t.name)),
                          DataCell(Text(t.subject)),
                          DataCell(Text(t.phone)),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => ref
                                  .read(teachersServiceProvider)
                                  .deleteTeacher(t.id),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) =>
                    Center(child: Text('تعذر تحميل بيانات المعلمين: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
