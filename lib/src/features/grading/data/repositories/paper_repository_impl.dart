import 'package:grade_ai/src/core/utils/result.dart';
import 'package:grade_ai/src/features/grading/domain/entities/exam_paper.dart';
import 'package:grade_ai/src/features/grading/domain/entities/grading_result.dart';
import 'package:grade_ai/src/features/grading/domain/repositories/paper_repository.dart';

/// Firebase-backed [PaperRepository].
///
/// TODO: inject FirebaseFirestore + FirebaseStorage and implement. Papers →
/// `papers/{id}`, page images → Storage `papers/{id}/page_n.jpg`, results →
/// `papers/{id}/result`.
class PaperRepositoryImpl implements PaperRepository {
  const PaperRepositoryImpl();

  @override
  Future<Result<ExamPaper>> savePaper(ExamPaper paper) => throw UnimplementedError();

  @override
  Future<Result<List<ExamPaper>>> watchPapers(String classId) => throw UnimplementedError();

  @override
  Future<Result<ExamPaper>> getPaper(String paperId) => throw UnimplementedError();

  @override
  Future<Result<void>> saveResult(GradingResult result) => throw UnimplementedError();

  @override
  Future<Result<GradingResult?>> getResult(String paperId) => throw UnimplementedError();

  @override
  Future<Result<void>> deletePaper(String paperId) => throw UnimplementedError();
}
