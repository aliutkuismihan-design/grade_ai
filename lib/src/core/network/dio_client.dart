import 'package:dio/dio.dart';
import 'package:grade_ai/src/core/config/env.dart';
import 'package:grade_ai/src/core/network/retry_interceptor.dart';

/// Builds the shared [Dio] instance pointed at the Grande AI backend,
/// with Bearer auth, timeouts, and exponential-backoff retry.
Dio buildDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.grandeAiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(minutes: 2), // grading can be slow
      sendTimeout: const Duration(minutes: 2), // large image uploads
      headers: {
        'Authorization': 'Bearer ${Env.grandeAiApiKey}',
      },
    ),
  );

  dio.interceptors.add(RetryInterceptor(dio: dio));

  assert(() {
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
    return true;
  }());

  return dio;
}
