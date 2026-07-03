import 'package:grade_ai/src/core/utils/result.dart';
import 'package:grade_ai/src/features/grading/domain/entities/exam_paper.dart';
import 'package:grade_ai/src/features/grading/domain/entities/grading_result.dart';

/// Persists scanned exam papers and their grading results (Firebase-backed
/// implementation lives in `data/repositories/paper_repository_impl.dart`).
abstract interface class PaperRepository {
  /// Uploads scanned page images and creates a paper record.
  Future<Result<ExamPaper>> savePaper(ExamPaper paper);

  Future<Result<List<ExamPaper>>> watchPapers(String classId);

  Future<Result<ExamPaper>> getPaper(String paperId);

  /// Stores the grading outcome for a previously-saved paper.
  Future<Result<void>> saveResult(GradingResult result);

  Future<Result<GradingResult?>> getResult(String paperId);

  Future<Result<void>> deletePaper(String paperId);
}
