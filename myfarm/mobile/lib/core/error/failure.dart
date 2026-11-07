/// A failure value carried through the data/repository layer to UI.
///
/// Instead of throwing exceptions across layer boundaries, operations
/// return an Either<Failure, T> style result where [Failure] holds the
/// typed exception and an optional user-facing message override.
class Failure {
  final AppException exception;
  final String? userMessageOverride;

  const Failure({
    required this.exception,
    this.userMessageOverride,
  });

  /// Localized key used by UI to look up the error string.
  String get messageKey => userMessageOverride ?? exception.messageKey;

  @override
  String toString() => 'Failure(${exception.runtimeType}, $messageKey)';
}
