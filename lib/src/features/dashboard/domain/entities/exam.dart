enum ExamStatus {
  draft,
  active,
  graded;

  String get label => switch (this) {
        ExamStatus.draft => 'Draft',
        ExamStatus.active => 'Active',
        ExamStatus.graded => 'Graded',
      };
}

class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.className,
    required this.status,
    required this.questionCount,
    required this.createdAt,
    this.averageScore,
  });

  final String id;
  final String title;
  final String className;
  final ExamStatus status;
  final int questionCount;
  final DateTime createdAt;

  /// Class average (0–100) once graded; null otherwise.
  final double? averageScore;
}
