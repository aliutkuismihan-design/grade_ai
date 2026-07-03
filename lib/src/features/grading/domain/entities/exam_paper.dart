/// A single scanned student exam paper awaiting or holding a grade.
class ExamPaper {
  const ExamPaper({
    required this.id,
    required this.studentName,
    required this.imagePaths,
    this.classId,
    this.createdAt,
  });

  final String id;
  final String studentName;

  /// Local file paths or remote (Firebase Storage) URLs of the scanned pages.
  final List<String> imagePaths;

  final String? classId;
  final DateTime? createdAt;

  ExamPaper copyWith({
    String? id,
    String? studentName,
    List<String>? imagePaths,
    String? classId,
    DateTime? createdAt,
  }) {
    return ExamPaper(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      imagePaths: imagePaths ?? this.imagePaths,
      classId: classId ?? this.classId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
