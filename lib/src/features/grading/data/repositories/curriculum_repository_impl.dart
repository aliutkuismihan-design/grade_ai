import 'package:grade_ai/src/core/utils/result.dart';
import 'package:grade_ai/src/features/grading/domain/entities/answer_key.dart';
import 'package:grade_ai/src/features/grading/domain/entities/rubric.dart';
import 'package:grade_ai/src/features/grading/domain/repositories/curriculum_repository.dart';

/// Firebase-backed [CurriculumRepository].
///
/// TODO: inject FirebaseFirestore and implement. Answer keys → `answer_keys/{id}`,
/// rubrics → `rubrics/{id}`, both scoped to the signed-in teacher.
class CurriculumRepositoryImpl implements CurriculumRepository {
  const CurriculumRepositoryImpl();

  @override
  Future<Result<AnswerKey>> saveAnswerKey(AnswerKey key) => throw UnimplementedError();

  @override
  Future<Result<List<AnswerKey>>> listAnswerKeys() => throw UnimplementedError();

  @override
  Future<Result<AnswerKey>> getAnswerKey(String id) => throw UnimplementedError();

  @override
  Future<Result<Rubric>> saveRubric(Rubric rubric) => throw UnimplementedError();

  @override
  Future<Result<List<Rubric>>> listRubrics() => throw UnimplementedError();

  @override
  Future<Result<Rubric>> getRubric(String id) => throw UnimplementedError();
}
