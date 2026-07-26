class Teacher {
  final String id;
  final String name;
  final String subject;
  final String phone;

  const Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.phone,
  });

  factory Teacher.fromMap(String id, Map<String, dynamic> map) {
    return Teacher(
      id: id,
      name: map['name'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subject': subject,
      'phone': phone,
    };
  }
}
