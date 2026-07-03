import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/src/features/dashboard/domain/entities/exam.dart';
import 'package:grade_ai/src/features/dashboard/domain/entities/student.dart';

// NOTE: mock data only. Swap these for Firestore-backed providers once the
// repositories land.

final _mockExams = <Exam>[
  Exam(
    id: 'e1',
    title: 'Biology — Cell Structure',
    className: '9-A',
    status: ExamStatus.graded,
    questionCount: 10,
    createdAt: DateTime(2026, 6, 12),
    averageScore: 74,
  ),
  Exam(
    id: 'e2',
    title: 'Physics — Kinematics',
    className: '10-B',
    status: ExamStatus.active,
    questionCount: 8,
    createdAt: DateTime(2026, 6, 28),
  ),
  Exam(
    id: 'e3',
    title: 'Chemistry — Bonding',
    className: '10-B',
    status: ExamStatus.draft,
    questionCount: 12,
    createdAt: DateTime(2026, 7, 1),
  ),
];

final _mockStudents = <Student>[
  const Student(id: 's1', name: 'Ada Yılmaz', className: '9-A', scoreHistory: [62, 71, 80, 88]),
  const Student(id: 's2', name: 'Bora Kaya', className: '9-A', scoreHistory: [90, 85, 92, 95]),
  const Student(id: 's3', name: 'Cem Demir', className: '9-A', scoreHistory: [40, 55, 58, 63]),
  const Student(id: 's4', name: 'Deniz Ak', className: '10-B', scoreHistory: [77, 74, 81]),
];

/// Search/filter text for the Exams tab.
final examSearchProvider = StateProvider<String>((ref) => '');

final examsProvider = Provider<List<Exam>>((ref) {
  final query = ref.watch(examSearchProvider).toLowerCase();
  final all = _mockExams;
  if (query.isEmpty) return all;
  return all
      .where((e) =>
          e.title.toLowerCase().contains(query) ||
          e.className.toLowerCase().contains(query))
      .toList();
});

final studentsProvider = Provider<List<Student>>((ref) => _mockStudents);

/// Class-wide analytics for the Results tab (mock).
final classAnalyticsProvider = Provider<ClassAnalytics>((ref) {
  return const ClassAnalytics(
    className: '9-A',
    averagePerQuestion: [82, 76, 44, 91, 68, 55, 79, 88, 34, 71],
    // Score buckets: 0-20, 21-40, 41-60, 61-80, 81-100.
    scoreDistribution: [1, 2, 5, 9, 6],
  );
});

class ClassAnalytics {
  const ClassAnalytics({
    required this.className,
    required this.averagePerQuestion,
    required this.scoreDistribution,
  });

  final String className;

  /// Average score (0–100) for each question index.
  final List<double> averagePerQuestion;

  /// Histogram counts across 5 score buckets.
  final List<int> scoreDistribution;

  /// 1-based number of the hardest question (lowest average).
  int get hardestQuestion {
    var minIdx = 0;
    for (var i = 1; i < averagePerQuestion.length; i++) {
      if (averagePerQuestion[i] < averagePerQuestion[minIdx]) minIdx = i;
    }
    return minIdx + 1;
  }
}
