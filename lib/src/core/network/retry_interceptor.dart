import 'dart:math';

import 'package:dio/dio.dart';

/// Retries idempotent-ish failures (timeouts, connection errors, 429, 5xx) with
/// exponential backoff + jitter. Non-retryable 4xx errors pass straight through.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 8),
  });

  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;

  static const _attemptKey = 'retry_attempt';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 0;

    if (!_shouldRetry(err) || attempt >= maxRetries) {
      return handler.next(err);
    }

    final delayMs = min(
      maxDelay.inMilliseconds,
      baseDelay.inMilliseconds * pow(2, attempt).toInt(),
    );
    final jitter = Random().nextInt(250);
    await Future<void>.delayed(Duration(milliseconds: delayMs + jitter));

    final options = err.requestOptions..extra[_attemptKey] = attempt + 1;
    try {
      final response = await dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final code = err.response?.statusCode ?? 0;
        return code == 429 || code >= 500;
      default:
        return false;
    }
  }
}
