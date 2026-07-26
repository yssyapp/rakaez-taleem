import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';

/// يغلّف أي صفحة تتطلب تسجيل دخول: يعيد التوجيه لـ /login تلقائيًا
/// إذا لم يكن هناك مستخدم مسجّل دخوله (يمنع الوصول المباشر عبر الروابط).
class RouteGuard extends ConsumerWidget {
  final Widget child;
  const RouteGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          });
          return const Scaffold(body: SizedBox.shrink());
        }
        return child;
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('خطأ في التحقق من تسجيل الدخول: $err')),
      ),
    );
  }
}
