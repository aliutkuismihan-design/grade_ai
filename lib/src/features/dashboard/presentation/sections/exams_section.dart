import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/src/features/dashboard/application/dashboard_providers.dart';
import 'package:grade_ai/src/features/dashboard/domain/entities/exam.dart';

class ExamsSection extends ConsumerWidget {
  const ExamsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exams = ref.watch(examsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (v) => ref.read(examSearchProvider.notifier).state = v,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search exams or classes',
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: exams.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _ExamCard(exams[i]),
          ),
        ),
      ],
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard(this.exam);
  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (exam.status) {
      ExamStatus.draft => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      ExamStatus.active => (scheme.secondary.withOpacity(0.2), scheme.secondary),
      ExamStatus.graded => (scheme.primary.withOpacity(0.2), scheme.primary),
    };

    return Card(
      child: ListTile(
        title: Text(exam.title),
        subtitle: Text('${exam.className} · ${exam.questionCount} questions'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(exam.status.label, style: TextStyle(color: fg, fontSize: 12)),
            ),
            if (exam.averageScore != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('avg ${exam.averageScore!.toStringAsFixed(0)}%'),
              ),
          ],
        ),
      ),
    );
  }
}
