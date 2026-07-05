import 'package:grade_ai/src/core/utils/result.dart';
import 'package:grade_ai/src/features/grading/domain/entities/answer_key.dart';
import 'package:grade_ai/src/features/grading/domain/entities/exam_paper.dart';
import 'package:grade_ai/src/features/grading/domain/entities/grading_result.dart';
import 'package:grade_ai/src/features/grading/domain/entities/rubric.dart';

/// Supported grading/UI languages.
enum GradingLanguage {
  en,
  fr,
  tr,
  es;

  String get code => name;
}

/// Pluggable grading engine. The concrete implementation
/// (`GrandeAIGradingService`) calls the Grande AI REST backend, but any
/// backend satisfying this contract can be swapped in via Riverpod.
abstract interface class GradingService {
  /// Grades [paper] against [answerKey] and [rubric] in [language].
  ///
  /// Implementations upload the scanned page(s), the model answer, and the
  /// rubric, then return a [GradingResult] (per-question scores, feedback,
  /// confidence, graded-PDF URL, OCR text) or a [Failure].
  Future<Result<GradingResult>> gradePaper({
    required ExamPaper paper,
    required AnswerKey answerKey,
    required Rubric rubric,
    required GradingLanguage language,
    List<String> curriculumTags,
  });

  /// Asks the backend to generate a rubric from a sample/model answer.
  /// Maps to `POST /rubric/generate`.
  Future<Result<Rubric>> generateRubric({
    required AnswerKey answerKey,
    required GradingLanguage language,
    List<String> curriculumTags,
  });
}
