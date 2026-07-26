import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/models/visit.dart';
import '../../../core/providers/visits_providers.dart';

/// نظام الزيارات والمواعيد: حجز موعد، تسجيل الوصول، متابعة الحالة.
class VisitsPage extends ConsumerWidget {
  const VisitsPage({super.key});

  Future<void> _openBookDialog(BuildContext context, WidgetRef ref) async {
    final guardianController = TextEditingController();
    final studentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    DateTime selectedDateTime = DateTime.now().add(const Duration(hours: 1));

    final result = await showDialog<Visit>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('حجز موعد زيارة'),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: guardianController,
                    decoration: const InputDecoration(labelText: 'اسم ولي الأمر'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: studentController,
                    decoration: const InputDecoration(labelText: 'اسم الطالب'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                        'الموعد: ${DateFormat('yyyy/MM/dd - HH:mm').format(selectedDateTime)}'),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: dialogContext,
                        initialDate: selectedDateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date == null) return;
                      if (!dialogContext.mounted) return;
                      final time = await showTimePicker(
                        context: dialogContext,
                        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                      );
                      if (time == null) return;
                      setDialogState(() {
                        selectedDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.of(dialogContext).pop(Visit(
                  id: '',
                  guardianName: guardianController.text.trim(),
                  studentName: studentController.text.trim(),
                  dateTime: selectedDateTime,
                  status: VisitStatus.scheduled,
                ));
              },
              child: const Text('حجز'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      await ref.read(visitsServiceProvider).addVisit(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(visitsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الزيارات والمواعيد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () => _openBookDialog(context, ref),
                child: const Text('حجز موعد جديد'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: visitsAsync.when(
                data: (visits) {
                  if (visits.isEmpty) {
                    return const Center(child: Text('لا توجد زيارات مجدولة'));
                  }
                  return ListView.separated(
                    itemCount: visits.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final v = visits[index];
                      return Card(
                        child: ListTile(
                          title: Text('${v.studentName} — ولي الأمر: ${v.guardianName}'),
                          subtitle: Text(
                              '${DateFormat('yyyy/MM/dd - HH:mm').format(v.dateTime)}  •  ${v.statusLabelAr}'),
                          trailing: PopupMenuButton<VisitStatus>(
                            onSelected: (status) => ref
                                .read(visitsServiceProvider)
                                .updateStatus(v.id, status),
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: VisitStatus.checkedIn,
                                child: Text('تسجيل الوصول'),
                              ),
                              PopupMenuItem(
                                value: VisitStatus.completed,
                                child: Text('إنهاء الزيارة'),
                              ),
                              PopupMenuItem(
                                value: VisitStatus.cancelled,
                                child: Text('إلغاء'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) =>
                    Center(child: Text('تعذر تحميل الزيارات: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
