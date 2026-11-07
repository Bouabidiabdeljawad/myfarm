import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Centralized logging wrapper for the myFarm mobile app.
///
/// Never log secrets, tokens, passwords, or PII. Use [AppLogger.d]
/// for debug diagnostics, [AppLogger.i] for info, [AppLogger.w] for
/// warnings, and [AppLogger.e] for errors.
class AppLogger {
  static final Logger _logger = Logger('myFarm');

  static void _init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord record) {
      if (kDebugMode) {
        print('${record.level.name}: ${record.time}: ${record.message}');
        if (record.error != null) {
          print('  error: ${record.error}');
        }
        if (record.stackTrace != null) {
          print('  stack: ${record.stackTrace}');
        }
      }
    });
  }

  static void d(Object? message, {StackTrace? stackTrace}) {
    _init();
    _logger.fine(message.toString(), stackTrace);
  }

  static void i(Object? message, {StackTrace? stackTrace}) {
    _init();
    _logger.info(message.toString(), stackTrace);
  }

  static void w(Object? message, {StackTrace? stackTrace}) {
    _init();
    _logger.warning(message.toString(), stackTrace);
  }

  static void e(Object? message, {StackTrace? stackTrace}) {
    _init();
    _logger.severe(message.toString(), stackTrace);
  }
}
