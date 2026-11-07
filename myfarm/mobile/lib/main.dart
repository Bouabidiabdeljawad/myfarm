import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_farm/app/app.dart';
import 'package:my_farm/core/logging/app_logger.dart';

void main() {
  // Enable structured logging and Flutter errors in debug mode
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.e(details.exception.toString(), stackTrace: details.stack);
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  runApp(const ProviderScope(child: MyApp()));
}
