import 'user_role.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final UserRole role;

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: UserRole.fromString(map['role'] as String?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role.name,
    };
  }
}
