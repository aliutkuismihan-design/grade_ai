import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/src/features/dashboard/application/dashboard_providers.dart';
import 'package:grade_ai/src/features/dashboard/domain/entities/student.dart';
import 'package:grade_ai/src/features/dashboard/presentation/widgets/simple_bar_chart.dart';

class StudentsSection extends ConsumerWidget {
  const StudentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text('Students', style: Theme.of(context).textTheme.titleLarge),
              ),
              OutlinedButton.icon(
                onPressed: () => _notImplemented(context, 'CSV import'),
                icon: const Icon(Icons.upload_file),
                label: const Text('Import CSV'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: students.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final s = students[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(s.name.characters.first)),
                  title: Text(s.name),
                  subtitle: Text('${s.className} · avg ${s.average.toStringAsFixed(0)}%'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showHistory(context, s),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showHistory(BuildContext context, Student s) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.name, style: Theme.of(context).textTheme.titleLarge),
            Text('Progress across exams', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 20),
            SimpleBarChart(
              values: s.scoreHistory,
              labels: [for (var i = 0; i < s.scoreHistory.length; i++) 'E${i + 1}'],
            ),
          ],
        ),
      ),
    );
  }

  void _notImplemented(BuildContext context, String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what — coming soon (uses file_picker + csv parsing).')),
    );
  }
}
