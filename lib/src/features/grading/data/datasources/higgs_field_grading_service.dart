import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:grade_ai/src/core/config/env.dart';
import 'package:grade_ai/src/core/error/failures.dart';
import 'package:grade_ai/src/core/network/offline_queue.dart';
import 'package:grade_ai/src/core/utils/result.dart';
import 'package:grade_ai/src/features/grading/domain/entities/answer_key.dart';
import 'package:grade_ai/src/features/grading/domain/entities/exam_paper.dart';
import 'package:grade_ai/src/features/grading/domain/entities/grading_result.dart';
import 'package:grade_ai/src/features/grading/domain/entities/rubric.dart';
import 'package:grade_ai/src/features/grading/domain/services/grading_service.dart';

/// [GradingService] backed by the **Higgs Field AI** REST backend running on the
/// user's private server.
///
/// Endpoints (base URL from `HIGGS_BASE_URL`):
///   • `POST /grade`            — multipart: paper_image, model_answer, rubric_json,
///                                language, curriculum_tags → per-question scores.
///   • `POST /rubric/generate`  — generate a rubric from a model answer.
///
/// Auth: `Authorization: Bearer <HIGGS_API_KEY>` (set on the shared Dio client).
/// Retry/backoff is handled by the Dio [RetryInterceptor]; when the device is
/// offline the request is parked in [OfflineGradingQueue] and retried later.
///
/// While `USE_MOCK_GRADING=true` this returns canned JSON so the app runs before
/// the backend is deployed.
class HiggsFieldGradingService implements GradingService {
  HiggsFieldGradingService(this._dio, this._queue);

  final Dio _dio;
  final OfflineGradingQueue _queue;

  @override
  Future<Result<GradingResult>> gradePaper({
    required ExamPaper paper,
    required AnswerKey answerKey,
    required Rubric rubric,
    required GradingLanguage language,
    List<String> curriculumTags = const [],
  }) async {
    if (Env.useMockGrading) {
      return Success(_mockResult(paper, answerKey));
    }

    // Park the request if we're offline; it flushes when connectivity returns.
    if (!await _queue.isOnline) {
      await _queue.enqueue(
        QueuedGradeRequest(
          id: paper.id,
          paperImagePath: paper.imagePaths.first,
          payload: {
            'rubric': _rubricJson(rubric),
            'model_answer': _answerKeyJson(answerKey),
            'language': language.code,
            'curriculum_tags': curriculumTags,
          },
        ),
      );
      return const Err(NetworkFailure('Offline — grade queued for retry'));
    }

    try {
      final form = FormData.fromMap({
        'paper_image': await MultipartFile.fromFile(paper.imagePaths.first),
        'model_answer': jsonEncode(_answerKeyJson(answerKey)),
        'rubric_json': jsonEncode(_rubricJson(rubric)),
        'language': language.code,
        'curriculum_tags': curriculumTags.join(','),
      });

      final response = await _dio.post<Map<String, dynamic>>('/grade', data: form);
      return Success(_parseGrade(response.data!, paper));
    } on DioException catch (e) {
      return Err(ServerFailure(
        e.message ?? 'Grading request failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Err(GradingFailure('Could not parse grading response: $e'));
    }
  }

  @override
  Future<Result<Rubric>> generateRubric({
    required AnswerKey answerKey,
    required GradingLanguage language,
    List<String> curriculumTags = const [],
  }) async {
    if (Env.useMockGrading) {
      return Success(_mockRubric(answerKey, curriculumTags));
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/rubric/generate',
        data: {
          'model_answer': _answerKeyJson(answerKey),
          'language': language.code,
          'curriculum_tags': curriculumTags,
        },
      );
      return Success(_parseRubric(response.data!));
    } on DioException catch (e) {
      return Err(ServerFailure(
        e.message ?? 'Rubric generation failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Err(GradingFailure('Could not parse rubric response: $e'));
    }
  }

  // --- JSON mapping --------------------------------------------------------

  Map<String, dynamic> _answerKeyJson(AnswerKey key) => {
        'id': key.id,
        'title': key.title,
        'questions': [
          for (final q in key.questions)
            {
              'question_number': q.questionNumber,
              'expected_answer': q.expectedAnswer,
              'max_points': q.maxPoints,
            },
        ],
      };

  Map<String, dynamic> _rubricJson(Rubric r) => {
        'id': r.id,
        'title': r.title,
        'curriculum': r.curriculum,
        'criteria': [
          for (final c in r.criteria)
            {'id': c.id, 'description': c.description, 'weight': c.weight},
        ],
      };

  GradingResult _parseGrade(Map<String, dynamic> body, ExamPaper paper) {
    final questions = (body['questions'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((q) => QuestionResult(
              questionNumber: q['question_number'].toString(),
              transcribedAnswer: q['ocr_text'] as String? ?? '',
              awardedPoints: (q['score'] as num).toDouble(),
              maxPoints: (q['max_points'] as num).toDouble(),
              feedback: q['feedback'] as String? ?? '',
              confidence: (q['confidence'] as num?)?.toDouble(),
            ))
        .toList();

    return GradingResult(
      paperId: paper.id,
      totalScore: (body['total_score'] as num?)?.toDouble() ??
          questions.fold(0, (s, q) => s + q.awardedPoints),
      maxScore: (body['max_score'] as num?)?.toDouble() ??
          questions.fold(0, (s, q) => s + q.maxPoints),
      questionResults: questions,
      overallFeedback: body['overall_feedback'] as String? ?? '',
      gradedPdfUrl: body['graded_pdf_url'] as String?,
      ocrRawText: body['ocr_raw_text'] as String?,
    );
  }

  Rubric _parseRubric(Map<String, dynamic> body) => Rubric(
        id: body['id'] as String,
        title: body['title'] as String,
        curriculum: body['curriculum'] as String? ?? '',
        criteria: (body['criteria'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map((c) => RubricCriterion(
                  id: c['id'] as String,
                  description: c['description'] as String,
                  weight: (c['weight'] as num).toDouble(),
                ))
            .toList(),
      );

  // --- Mocks ---------------------------------------------------------------

  GradingResult _mockResult(ExamPaper paper, AnswerKey answerKey) {
    final results = answerKey.questions
        .map((q) => QuestionResult(
              questionNumber: q.questionNumber,
              transcribedAnswer: '[mock OCR of Q${q.questionNumber}]',
              awardedPoints: q.maxPoints * 0.8,
              maxPoints: q.maxPoints,
              feedback: 'Mock feedback — enable the real backend in .env.',
              confidence: 0.87,
            ))
        .toList();

    return GradingResult(
      paperId: paper.id,
      totalScore: results.fold(0, (s, q) => s + q.awardedPoints),
      maxScore: results.fold(0, (s, q) => s + q.maxPoints),
      questionResults: results,
      overallFeedback:
          'Mock grade for ${paper.studentName}. Set USE_MOCK_GRADING=false once the Higgs Field AI server is live.',
      gradedPdfUrl: null,
      ocrRawText: '[mock OCR raw text]',
    );
  }

  Rubric _mockRubric(AnswerKey key, List<String> tags) => Rubric(
        id: 'mock-rubric',
        title: 'Generated from ${key.title}',
        curriculum: tags.join(', '),
        criteria: const [
          RubricCriterion(id: 'c1', description: 'Correctness of the final answer', weight: 0.6),
          RubricCriterion(id: 'c2', description: 'Method and reasoning shown', weight: 0.4),
        ],
      );
}
