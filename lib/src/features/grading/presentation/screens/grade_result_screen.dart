import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grade_ai/src/core/theme/app_theme.dart';
import 'package:grade_ai/src/features/grading/domain/entities/grading_result.dart';
import 'package:grade_ai/src/features/grading/presentation/screens/upload_grade_screen.dart';
import 'package:grade_ai/src/features/scan/application/scan_providers.dart';

/// Displays the AI grading result with per-question breakdown.
class GradeResultScreen extends ConsumerStatefulWidget {
  const GradeResultScreen({super.key});

  @override
  ConsumerState<GradeResultScreen> createState() => _GradeResultScreenState();
}

class _GradeResultScreenState extends ConsumerState<GradeResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(gradingStateProvider).valueOrNull;
    if (result == null) {
      return const Scaffold(
        body: Center(child: Text('No grading result yet')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grading Result'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score hero
            _scoreCard(result),
            const SizedBox(height: 24),

            // Per-question breakdown
            _sectionTitle('Question Breakdown'),
            const SizedBox(height: 12),
            ...result.questionResults.map((q) => _questionCard(q)),
            const SizedBox(height: 24),

            // Overall feedback
            if (result.overallFeedback.isNotEmpty)
              _feedbackCard(result.overallFeedback),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Marked PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Export Excel'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: () {
                  ref.read(capturedImageProvider.notifier).state = null;
                  ref.read(gradingStateProvider.notifier).state = const AsyncValue.data(null);
                  context.push('/scan');
                },
                icon: const Icon(Icons.add),
                label: const Text('Grade Another Paper'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _scoreCard(GradingResult result) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        final animatedScore = result.totalScore * _scoreAnimation.value;
        final animatedMax = result.maxScore * _scoreAnimation.value;
        final pct = result.percentage;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withOpacity(0.2),
                AppTheme.secondary.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              const Text(
                'TOTAL SCORE',
                style: TextStyle(fontSize: 12, letterSpacing: 2, color: Colors.white54),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    animatedScore.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      ' / ${result.maxScore.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, color: Colors.white54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _gradeColor(pct).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _gradeColor(pct).withOpacity(0.4)),
                ),
                child: Text(
                  _gradeLabel(pct),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _gradeColor(pct),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _scoreAnimation.value * (pct / 100),
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(_gradeColor(pct)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _questionCard(QuestionResult q) {
    final pct = q.maxPoints == 0 ? 0.0 : (q.awardedPoints / q.maxPoints).toDouble();
    final isGood = pct >= 0.7;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: isGood ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          child: Text(
            q.questionNumber,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isGood ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(isGood ? Colors.greenAccent : Colors.redAccent),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${q.awardedPoints.toStringAsFixed(0)}/${q.maxPoints.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        subtitle: q.confidence != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      q.confidence! > 0.9 ? Icons.verified : Icons.help_outline,
                      size: 14,
                      color: q.confidence! > 0.9 ? Colors.tealAccent : Colors.amberAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Confidence: ${(q.confidence! * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: q.confidence! > 0.9 ? Colors.tealAccent : Colors.amberAccent,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (q.transcribedAnswer.isNotEmpty) ...[
                  const Text(
                    'OCR Transcription',
                    style: TextStyle(fontSize: 11, color: Colors.white54, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(q.transcribedAnswer, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 12),
                ],
                const Text(
                  'AI Feedback',
                  style: TextStyle(fontSize: 11, color: Colors.white54, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(q.feedback, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard(String feedback) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, size: 16, color: AppTheme.accent),
              const SizedBox(width: 6),
              Text(
                'Overall Feedback',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(feedback, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _gradeColor(double pct) {
    if (pct >= 90) return Colors.greenAccent;
    if (pct >= 70) return Colors.tealAccent;
    if (pct >= 50) return AppTheme.accent;
    return Colors.redAccent;
  }

  String _gradeLabel(double pct) {
    if (pct >= 97) return 'A+';
    if (pct >= 93) return 'A';
    if (pct >= 90) return 'A-';
    if (pct >= 87) return 'B+';
    if (pct >= 83) return 'B';
    if (pct >= 80) return 'B-';
    if (pct >= 77) return 'C+';
    if (pct >= 73) return 'C';
    if (pct >= 70) return 'C-';
    if (pct >= 67) return 'D+';
    if (pct >= 63) return 'D';
    if (pct >= 60) return 'D-';
    return 'F';
  }
}
