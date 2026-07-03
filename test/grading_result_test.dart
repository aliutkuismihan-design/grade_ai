import 'package:flutter_test/flutter_test.dart';
import 'package:grade_ai/src/features/grading/domain/entities/grading_result.dart';

void main() {
  group('GradingResult.percentage', () {
    test('computes percentage from total/max score', () {
      const result = GradingResult(
        paperId: 'p1',
        totalScore: 8,
        maxScore: 10,
        questionResults: [],
        overallFeedback: '',
      );
      expect(result.percentage, 80);
    });

    test('is 0 when maxScore is 0 (no divide-by-zero)', () {
      const result = GradingResult(
        paperId: 'p1',
        totalScore: 0,
        maxScore: 0,
        questionResults: [],
        overallFeedback: '',
      );
      expect(result.percentage, 0);
    });
  });
}
