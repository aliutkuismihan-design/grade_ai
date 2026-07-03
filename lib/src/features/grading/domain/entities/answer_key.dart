/// The teacher-supplied model answer key a paper is graded against.
class AnswerKey {
  const AnswerKey({
    required this.id,
    required this.title,
    required this.questions,
  });

  final String id;
  final String title;
  final List<AnswerKeyItem> questions;
}

class AnswerKeyItem {
  const AnswerKeyItem({
    required this.questionNumber,
    required this.expectedAnswer,
    required this.maxPoints,
  });

  final String questionNumber;
  final String expectedAnswer;
  final double maxPoints;
}
