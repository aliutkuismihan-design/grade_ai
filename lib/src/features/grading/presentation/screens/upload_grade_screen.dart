import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grade_ai/src/core/theme/app_theme.dart';
import 'package:grade_ai/src/features/grading/domain/entities/answer_key.dart';
import 'package:grade_ai/src/features/grading/domain/entities/exam_paper.dart';
import 'package:grade_ai/src/features/grading/domain/entities/rubric.dart';
import 'package:grade_ai/src/features/grading/domain/services/grading_service.dart';
import 'package:grade_ai/src/features/grading/presentation/widgets/grading_progress.dart';
import 'package:grade_ai/src/features/grading/presentation/widgets/rubric_editor.dart';
import 'package:grade_ai/src/features/scan/application/scan_providers.dart';

final _gradingStateProvider = StateProvider<AsyncValue<GradingResult?>>((ref) => const AsyncValue.data(null));

final _answerKeyProvider = StateProvider<AnswerKey>((ref) => AnswerKey(
  id: 'temp-key',
  title: 'Sample Exam',
  questions: [
    AnswerKeyItem(questionNumber: '1', expectedAnswer: 'Answer 1', maxPoints: 10),
    AnswerKeyItem(questionNumber: '2', expectedAnswer: 'Answer 2', maxPoints: 10),
    AnswerKeyItem(questionNumber: '3', expectedAnswer: 'Answer 3', maxPoints: 10),
  ],
));

final _rubricProvider = StateProvider<Rubric>((ref) => const Rubric(
  id: 'temp-rubric',
  title: 'Default Rubric',
  curriculum: 'General',
  criteria: [
    RubricCriterion(id: 'c1', description: 'Correctness', weight: 0.6),
    RubricCriterion(id: 'c2', description: 'Method', weight: 0.4),
  ],
));

final _gradeLevelProvider = StateProvider<int>((ref) => 3);
final _languageProvider = StateProvider<GradingLanguage>((ref) => GradingLanguage.en);

/// Upload model answer + rubric, then trigger AI grading.
class UploadGradeScreen extends ConsumerWidget {
  const UploadGradeScreen({super.key});

  static const _levels = ['Elementary', 'Middle School', 'High School', 'University'];
  static const _langs = [
    (GradingLanguage.en, 'English'),
    (GradingLanguage.fr, 'French'),
    (GradingLanguage.tr, 'Turkish'),
    (GradingLanguage.es, 'Spanish'),
  ];

  Future<void> _grade(BuildContext context, WidgetRef ref) async {
    final image = ref.read(capturedImageProvider);
    if (image == null) return;

    ref.read(_gradingStateProvider.notifier).state = const AsyncValue.loading();

    // Simulate delay for demo
    await Future.delayed(const Duration(seconds: 3));

    final result = GradingResult(
      paperId: 'paper-${DateTime.now().millisecondsSinceEpoch}',
      totalScore: 85,
      maxScore: 100,
      questionResults: [
        QuestionResult(
          questionNumber: '1',
          transcribedAnswer: 'Student wrote the correct formula.',
          awardedPoints: 30,
          maxPoints: 30,
          feedback: 'Perfect — correct formula and substitution.',
          confidence: 0.95,
        ),
        QuestionResult(
          questionNumber: '2',
          transcribedAnswer: 'Minor arithmetic error in step 3.',
          awardedPoints: 38,
          maxPoints: 40,
          feedback: 'Correct method, small calculation slip (-2).',
          confidence: 0.91,
        ),
        QuestionResult(
          questionNumber: '3',
          transcribedAnswer: 'Missed edge case.',
          awardedPoints: 17,
          maxPoints: 30,
          feedback: 'Good start but missing the boundary condition (-13).',
          confidence: 0.78,
        ),
      ],
      overallFeedback: 'Strong performance on Q1 and Q2. Review boundary conditions for Q3.',
      gradedPdfUrl: null,
      ocrRawText: null,
    );

    ref.read(_gradingStateProvider.notifier).state = AsyncValue.data(result);

    if (context.mounted) {
      context.push('/results');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(capturedImageProvider);
    final gradingState = ref.watch(_gradingStateProvider);
    final isLoading = gradingState.isLoading;

    if (isLoading) {
      return const Scaffold(
        body: GradingProgress(message: 'Higgs Field AI is grading...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail of scanned paper
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image, height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 20),

            // Grade level selector
            _sectionTitle('Grade Level'),
            Wrap(
              spacing: 8,
              children: _levels.asMap().entries.map((e) {
                final selected = ref.watch(_gradeLevelProvider) == e.key + 1;
                return ChoiceChip(
                  label: Text(e.value),
                  selected: selected,
                  onSelected: (_) => ref.read(_gradeLevelProvider.notifier).state = e.key + 1,
                  selectedColor: AppTheme.primary.withOpacity(0.2),
                  checkmarkColor: AppTheme.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Language selector
            _sectionTitle('Grading Language'),
            Wrap(
              spacing: 8,
              children: _langs.map((l) {
                final selected = ref.watch(_languageProvider) == l.$1;
                return ChoiceChip(
                  label: Text(l.$2),
                  selected: selected,
                  onSelected: (_) => ref.read(_languageProvider.notifier).state = l.$1,
                  selectedColor: AppTheme.secondary.withOpacity(0.2),
                  checkmarkColor: AppTheme.secondary,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Rubric editor
            RubricEditor(
              rubric: ref.watch(_rubricProvider),
              onChanged: (r) => ref.read(_rubricProvider.notifier).state = r,
            ),
            const SizedBox(height: 24),

            // Grade button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: () => _grade(context, ref),
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Grade with AI', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
      ),
    );
  }
}
