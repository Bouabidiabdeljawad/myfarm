/// Base exception type for the myFarm mobile application.
///
/// All domain, infrastructure, and presentation errors are modeled
/// as subtypes of [AppException] so UI layers can render a
/// consistent error state without knowing implementation details.
abstract class AppException implements Exception {
  /// Human-readable error key used for localization lookup.
  final String messageKey;

  /// Optional underlying cause (e.g. DioException, SocketException).
  final Object? cause;

  /// Optional stack trace captured at the point of failure.
  final StackTrace? stackTrace;

  AppException({
    required this.messageKey,
    this.cause,
    this.stackTrace,
  }) : super();

  @override
  String toString() => '$runtimeType: $messageKey';
}

/// Thrown when the device is offline and a network call is required.
class NetworkException extends AppException {
  NetworkException({Object? cause, StackTrace? stackTrace})
      : super(messageKey: 'error.network', cause: cause, stackTrace: stackTrace);
}

/// Thrown when the server returns an error status code.
class ServerException extends AppException {
  final int statusCode;

  ServerException({
    required this.statusCode,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(messageKey: 'error.server', cause: cause, stackTrace: stackTrace);

  @override
  String toString() => 'ServerException(statusCode=$statusCode, $messageKey)';
}

/// Thrown when authentication fails (Phase 02+).
class AuthException extends AppException {
  AuthException({Object? cause, StackTrace? stackTrace})
      : super(messageKey: 'error.auth', cause: cause, stackTrace: stackTrace);
}

/// Thrown when local database operations fail.
class DatabaseException extends AppException {
  DatabaseException({Object? cause, StackTrace? stackTrace})
      : super(messageKey: 'error.database', cause: cause, stackTrace: stackTrace);
}

/// Thrown when secure storage operations fail.
class SecureStorageException extends AppException {
  SecureStorageException({Object? cause, StackTrace? stackTrace})
      : super(messageKey: 'error.secure_storage', cause: cause, stackTrace: stackTrace);
}

/// Thrown when input validation fails before a call is made.
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException({
    this.fieldErrors,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(messageKey: 'error.validation', cause: cause, stackTrace: stackTrace);
}
