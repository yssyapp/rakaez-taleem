import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/providers/dashboard_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم - منصة ركائز التعليم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (r) => false);
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildContent(ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF263238),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              'القائمة الرئيسية',
              style: TextStyle(color: Colors.white),
            ),
          ),
          _sidebarItem(context, title: 'الطلاب', route: '/students'),
          _sidebarItem(context, title: 'المعلمين', route: '/teachers'),
          _sidebarItem(context, title: 'الزيارات والمواعيد', route: '/visits'),
          _sidebarItem(context, title: 'التقارير', route: '/reports'),
        ],
      ),
    );
  }

  Widget _sidebarItem(BuildContext context,
      {required String title, required String route}) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }

  Widget _buildContent(WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إحصائيات سريعة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        statsAsync.when(
          data: (stats) => Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(title: 'عدد الطلاب', value: '${stats.studentsCount}'),
              _StatCard(title: 'عدد المعلمين', value: '${stats.teachersCount}'),
              _StatCard(
                  title: 'زيارات اليوم', value: '${stats.todayVisitsCount}'),
              _StatCard(
                  title: 'نسبة الحضور',
                  value: '${stats.attendanceRate.toStringAsFixed(0)}%'),
            ],
          ),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => Text(
            'تعذر تحميل الإحصائيات: $err',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
