import 'package:grade_ai/src/core/error/failures.dart';

/// A minimal Either-style result. Left = [Failure], Right = value [T].
///
/// Kept intentionally tiny to avoid a dependency; swap for `fpdart`/`dartz`
/// later if richer combinators are needed.
sealed class Result<T> {
  const Result();

  R fold<R>(R Function(Failure failure) onFailure, R Function(T value) onSuccess);

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;

  @override
  R fold<R>(R Function(Failure failure) onFailure, R Function(T value) onSuccess) =>
      onSuccess(value);
}

class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;

  @override
  R fold<R>(R Function(Failure failure) onFailure, R Function(T value) onSuccess) =>
      onFailure(failure);
}
