/// The outcome of grading one [ExamPaper] via the Grande AI backend.
class GradingResult {
  const GradingResult({
    required this.paperId,
    required this.totalScore,
    required this.maxScore,
    required this.questionResults,
    required this.overallFeedback,
    this.gradedPdfUrl,
    this.ocrRawText,
  });

  final String paperId;
  final double totalScore;
  final double maxScore;
  final List<QuestionResult> questionResults;
  final String overallFeedback;

  /// URL of the annotated/graded PDF returned by the backend (if any).
  final String? gradedPdfUrl;

  /// Raw OCR transcription of the whole paper returned by the backend.
  final String? ocrRawText;

  double get percentage => maxScore == 0 ? 0 : (totalScore / maxScore) * 100;
}

class QuestionResult {
  const QuestionResult({
    required this.questionNumber,
    required this.transcribedAnswer,
    required this.awardedPoints,
    required this.maxPoints,
    required this.feedback,
    this.confidence,
  });

  final String questionNumber;

  /// The backend's OCR transcription of the handwritten answer.
  final String transcribedAnswer;

  final double awardedPoints;
  final double maxPoints;
  final String feedback;

  /// Model confidence for this question's grade, 0.0–1.0 (null if not reported).
  final double? confidence;
}
