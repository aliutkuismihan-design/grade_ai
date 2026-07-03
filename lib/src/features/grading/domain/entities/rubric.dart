/// A curriculum-aligned grading rubric. The AI grades each answer against these
/// criteria rather than only exact-matching the answer key.
class Rubric {
  const Rubric({
    required this.id,
    required this.title,
    required this.curriculum,
    required this.criteria,
  });

  final String id;
  final String title;

  /// e.g. "MEB 9th Grade Biology", "IB HL Physics", "AP Calculus AB".
  final String curriculum;

  final List<RubricCriterion> criteria;
}

class RubricCriterion {
  const RubricCriterion({
    required this.id,
    required this.description,
    required this.weight,
  });

  final String id;
  final String description;

  /// Relative weight of this criterion when scoring (0.0–1.0).
  final double weight;
}
