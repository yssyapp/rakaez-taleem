import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// يبث حالة تسجيل الدخول من Firebase (مستخدم مسجل أو لا)
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

/// يجلب بيانات المستخدم الحالي (بما فيها الدور) من Firestore بعد تسجيل الدخول
final currentAppUserProvider = FutureProvider<AppUser?>((ref) async {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      return ref.watch(authServiceProvider).fetchCurrentAppUser();
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
