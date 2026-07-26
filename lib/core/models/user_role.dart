/// أدوار المستخدمين في النظام (نظام الصلاحيات - المرحلة الخامسة من الخطة)
enum UserRole {
  admin,
  teacher,
  student,
  staff;

  static UserRole fromString(String? value) {
    return UserRole.values.firstWhere(
      (r) => r.name == value,
      orElse: () => UserRole.staff,
    );
  }

  String get labelAr {
    switch (this) {
      case UserRole.admin:
        return 'مدير';
      case UserRole.teacher:
        return 'معلم';
      case UserRole.student:
        return 'طالب';
      case UserRole.staff:
        return 'موظف';
    }
  }
}
