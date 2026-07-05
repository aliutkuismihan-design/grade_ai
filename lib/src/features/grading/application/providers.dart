import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/src/core/network/dio_client.dart';
import 'package:grade_ai/src/core/network/offline_queue.dart';
import 'package:grade_ai/src/features/grading/data/datasources/grande_ai_grading_service.dart';
import 'package:grade_ai/src/features/grading/domain/services/grading_service.dart';

/// Shared Dio client (base URL + Bearer auth + retry, from [buildDio]).
final dioProvider = Provider<Dio>((ref) {
  final dio = buildDio();
  ref.onDispose(dio.close);
  return dio;
});

/// Offline upload queue — parks grade requests while offline, flushes on reconnect.
final offlineQueueProvider = Provider<OfflineGradingQueue>((ref) {
  final queue = OfflineGradingQueue();
  ref.onDispose(queue.dispose);
  return queue;
});

/// The pluggable grading engine — bound to [GrandeAIGradingService].
/// Override in tests or to swap backends without touching call sites.
final gradingServiceProvider = Provider<GradingService>((ref) {
  return GrandeAIGradingService(
    ref.watch(dioProvider),
    ref.watch(offlineQueueProvider),
  );
});

// TODO: once the Firebase-backed impls exist, expose them here:
//   final paperRepositoryProvider = Provider<PaperRepository>(...);
//   final curriculumRepositoryProvider = Provider<CurriculumRepository>(...);
