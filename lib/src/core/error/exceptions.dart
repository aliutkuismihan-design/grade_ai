/// Low-level exceptions thrown by data sources. The repository layer catches
/// these and converts them into [Failure]s (see `failures.dart`).
class ServerException implements Exception {
  const ServerException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);
  final String message;
}

class GradingException implements Exception {
  const GradingException(this.message);
  final String message;
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}
