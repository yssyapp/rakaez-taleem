class Student {
  final String id;
  final String name;
  final String className;
  final String status; // منتظم / متغيب
  final String? guardianPhone;
  final String? notes;

  const Student({
    required this.id,
    required this.name,
    required this.className,
    required this.status,
    this.guardianPhone,
    this.notes,
  });

  factory Student.fromMap(String id, Map<String, dynamic> map) {
    return Student(
      id: id,
      name: map['name'] as String? ?? '',
      className: map['className'] as String? ?? '',
      status: map['status'] as String? ?? 'منتظم',
      guardianPhone: map['guardianPhone'] as String?,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'className': className,
      'status': status,
      'guardianPhone': guardianPhone,
      'notes': notes,
    };
  }

  Student copyWith({
    String? name,
    String? className,
    String? status,
    String? guardianPhone,
    String? notes,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      className: className ?? this.className,
      status: status ?? this.status,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      notes: notes ?? this.notes,
    );
  }
}
