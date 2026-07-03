import 'package:grade_ai/src/core/utils/result.dart';
import 'package:grade_ai/src/features/grading/domain/entities/answer_key.dart';
import 'package:grade_ai/src/features/grading/domain/entities/rubric.dart';

/// Manages the teacher's answer keys and curriculum rubrics
/// (Firebase-backed implementation in `data/repositories`).
abstract interface class CurriculumRepository {
  Future<Result<AnswerKey>> saveAnswerKey(AnswerKey key);
  Future<Result<List<AnswerKey>>> listAnswerKeys();
  Future<Result<AnswerKey>> getAnswerKey(String id);

  Future<Result<Rubric>> saveRubric(Rubric rubric);
  Future<Result<List<Rubric>>> listRubrics();
  Future<Result<Rubric>> getRubric(String id);
}
