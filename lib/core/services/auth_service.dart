import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

/// خدمة المصادقة: تسجيل الدخول/الخروج وربط المستخدم بدوره في Firestore.
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw AuthException('لا يوجد ملف صلاحيات لهذا المستخدم، تواصل مع الإدارة.');
      }
      return AppUser.fromMap(uid, doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }

  Future<AppUser?> fetchCurrentAppUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(user.uid, doc.data()!);
  }

  Future<void> signOut() => _auth.signOut();

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صحيحة';
      case 'user-disabled':
        return 'تم إيقاف هذا الحساب، تواصل مع الإدارة';
      case 'too-many-requests':
        return 'محاولات كثيرة، حاول لاحقًا';
      default:
        return 'حدث خطأ أثناء تسجيل الدخول، حاول مرة أخرى';
    }
  }
}
