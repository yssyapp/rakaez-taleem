import 'package:cloud_firestore/cloud_firestore.dart';

enum VisitStatus { scheduled, checkedIn, completed, cancelled }

class Visit {
  final String id;
  final String guardianName;
  final String studentName;
  final DateTime dateTime;
  final VisitStatus status;
  final String? notes;

  const Visit({
    required this.id,
    required this.guardianName,
    required this.studentName,
    required this.dateTime,
    required this.status,
    this.notes,
  });

  factory Visit.fromMap(String id, Map<String, dynamic> map) {
    return Visit(
      id: id,
      guardianName: map['guardianName'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      dateTime: (map['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: VisitStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => VisitStatus.scheduled,
      ),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'guardianName': guardianName,
      'studentName': studentName,
      'dateTime': Timestamp.fromDate(dateTime),
      'status': status.name,
      'notes': notes,
    };
  }

  String get statusLabelAr {
    switch (status) {
      case VisitStatus.scheduled:
        return 'محجوز';
      case VisitStatus.checkedIn:
        return 'تم تسجيل الوصول';
      case VisitStatus.completed:
        return 'مكتمل';
      case VisitStatus.cancelled:
        return 'ملغى';
    }
  }
}
