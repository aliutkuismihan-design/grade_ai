import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/src/features/dashboard/application/dashboard_providers.dart';
import 'package:grade_ai/src/features/dashboard/presentation/widgets/simple_bar_chart.dart';

class ResultsSection extends ConsumerWidget {
  const ResultsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(classAnalyticsProvider);
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: Text('Class ${a.className} analytics', style: text.titleLarge)),
            OutlinedButton.icon(
              onPressed: () => _notImplemented(context, 'Excel export'),
              icon: const Icon(Icons.grid_on),
              label: const Text('Export'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.warning_amber_rounded),
            title: Text('Hardest question: Q${a.hardestQuestion}'),
            subtitle: const Text('Lowest average across the class'),
          ),
        ),
        const SizedBox(height: 16),
        Text('Average score per question', style: text.titleMedium),
        const SizedBox(height: 12),
        SimpleBarChart(
          values: a.averagePerQuestion,
          labels: [for (var i = 0; i < a.averagePerQuestion.length; i++) 'Q${i + 1}'],
          highlightIndex: a.hardestQuestion - 1,
        ),
        const SizedBox(height: 24),
        Text('Score distribution', style: text.titleMedium),
        const SizedBox(height: 12),
        SimpleBarChart(
          values: a.scoreDistribution.map((e) => e.toDouble()).toList(),
          labels: const ['0-20', '21-40', '41-60', '61-80', '81-100'],
          maxValue: (a.scoreDistribution.reduce((x, y) => x > y ? x : y)).toDouble(),
          barColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  void _notImplemented(BuildContext context, String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what — coming soon (uses the `excel` package).')),
    );
  }
}
