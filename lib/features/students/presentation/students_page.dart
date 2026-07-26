import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/student.dart';
import '../../../core/providers/students_providers.dart';
import 'student_form_dialog.dart';

class StudentsPage extends ConsumerStatefulWidget {
  const StudentsPage({super.key});

  @override
  ConsumerState<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends ConsumerState<StudentsPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddDialog() async {
    final result = await showDialog<Student>(
      context: context,
      builder: (_) => const StudentFormDialog(),
    );
    if (result != null) {
      await ref.read(studentsServiceProvider).addStudent(result);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('تمت إضافة الطالب')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الطلاب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'بحث عن طالب',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() => _query = v.trim()),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _openAddDialog,
                  child: const Text('إضافة طالب جديد'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: studentsAsync.when(
                data: (students) {
                  final filtered = _query.isEmpty
                      ? students
                      : students
                          .where((s) => s.name.contains(_query))
                          .toList();
                  return _buildStudentsTable(filtered);
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, stack) =>
                    Center(child: Text('تعذر تحميل بيانات الطلاب: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsTable(List<Student> students) {
    if (students.isEmpty) {
      return const Center(child: Text('لا يوجد طلاب مطابقون'));
    }
    return SingleChildScrollView(
      child: Card(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('الاسم')),
            DataColumn(label: Text('الصف')),
            DataColumn(label: Text('الحالة')),
            DataColumn(label: Text('الملف')),
          ],
          rows: students.map((s) {
            return DataRow(
              cells: [
                DataCell(Text(s.name)),
                DataCell(Text(s.className)),
                DataCell(Text(s.status)),
                DataCell(
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/students/details',
                        arguments: s.id,
                      );
                    },
                    child: const Text('عرض'),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
