import 'package:flutter/material.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/students/presentation/students_page.dart';
import '../../features/students/presentation/student_details_page.dart';
import '../../features/teachers/presentation/teachers_page.dart';
import '../../features/visits/presentation/visits_page.dart';
import '../../features/reports/presentation/reports_page.dart';
import 'route_guard.dart';

/// المسارات المحمية: تتطلب تسجيل دخول قبل الوصول لها.
/// (نظام الصلاحيات التفصيلي حسب الدور سيُبنى فوق هذا الأساس في مرحلة لاحقة)
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const RouteGuard(child: DashboardPage()),
        );
      case '/students':
        return MaterialPageRoute(
          builder: (_) => const RouteGuard(child: StudentsPage()),
        );
      case '/students/details':
        final studentId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            child: StudentDetailsPage(studentId: studentId),
          ),
        );
      case '/teachers':
        return MaterialPageRoute(
          builder: (_) => const RouteGuard(child: TeachersPage()),
        );
      case '/visits':
        return MaterialPageRoute(
          builder: (_) => const RouteGuard(child: VisitsPage()),
        );
      case '/reports':
        return MaterialPageRoute(
          builder: (_) => const RouteGuard(child: ReportsPage()),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
