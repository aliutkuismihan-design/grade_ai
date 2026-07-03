class Student {
  const Student({
    required this.id,
    required this.name,
    required this.className,
    required this.scoreHistory,
  });

  final String id;
  final String name;
  final String className;

  /// Chronological exam scores (0–100) for the progress chart.
  final List<double> scoreHistory;

  double get average =>
      scoreHistory.isEmpty ? 0 : scoreHistory.reduce((a, b) => a + b) / scoreHistory.length;
}
