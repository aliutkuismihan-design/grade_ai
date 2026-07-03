/// Domain-facing error type. Repositories return `Result<Failure, T>` rather
/// than throwing, so the presentation layer handles both branches explicitly.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class GradingFailure extends Failure {
  const GradingFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
