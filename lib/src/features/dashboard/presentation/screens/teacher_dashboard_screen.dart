import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grade_ai/src/features/ads/presentation/widgets/banner_ad_widget.dart';
import 'package:grade_ai/src/features/dashboard/presentation/sections/exams_section.dart';
import 'package:grade_ai/src/features/dashboard/presentation/sections/results_section.dart';
import 'package:grade_ai/src/features/dashboard/presentation/sections/settings_section.dart';
import 'package:grade_ai/src/features/dashboard/presentation/sections/students_section.dart';

/// Teacher Dashboard — the app's home. Four sections via bottom navigation,
/// with a banner ad pinned above the nav bar (non-grading screens only).
class TeacherDashboardScreen extends ConsumerStatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  ConsumerState<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends ConsumerState<TeacherDashboardScreen> {
  int _index = 0;

  static const _titles = ['Exams', 'Students', 'Results', 'Settings'];
  static const _sections = [
    ExamsSection(),
    StudentsSection(),
    ResultsSection(),
    SettingsSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: Column(
        children: [
          Expanded(child: _sections[_index]),
          const BannerAdWidget(), // banner on all non-grading screens
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/scan'),
              icon: const Icon(Icons.add),
              label: const Text('New exam'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.assignment_outlined), label: 'Exams'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Results'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
