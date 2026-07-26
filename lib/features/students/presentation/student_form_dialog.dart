import 'package:flutter/material.dart';
import '../../../core/models/student.dart';

/// نافذة إضافة/تعديل طالب. تُعيد Student جديد أو معدّل عند الحفظ، أو null عند الإلغاء.
class StudentFormDialog extends StatefulWidget {
  final Student? existing;
  const StudentFormDialog({super.key, this.existing});

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _classController;
  late final TextEditingController _guardianPhoneController;
  String _status = 'منتظم';

  @override
  void initState() {
    super.initState();
    final s = widget.existing;
    _nameController = TextEditingController(text: s?.name ?? '');
    _classController = TextEditingController(text: s?.className ?? '');
    _guardianPhoneController =
        TextEditingController(text: s?.guardianPhone ?? '');
    _status = s?.status ?? 'منتظم';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final result = Student(
      id: widget.existing?.id ?? '',
      name: _nameController.text.trim(),
      className: _classController.text.trim(),
      status: _status,
      guardianPhone: _guardianPhoneController.text.trim(),
      notes: widget.existing?.notes,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'إضافة طالب جديد' : 'تعديل بيانات الطالب'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم الطالب'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'الصف'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _guardianPhoneController,
                decoration: const InputDecoration(labelText: 'جوال ولي الأمر'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'الحالة'),
                items: const [
                  DropdownMenuItem(value: 'منتظم', child: Text('منتظم')),
                  DropdownMenuItem(value: 'متغيب', child: Text('متغيب')),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'منتظم'),
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
          onPressed: _save,
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
