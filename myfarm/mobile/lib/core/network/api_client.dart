import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:my_farm/core/error/app_exception.dart';
import 'package:my_farm/core/logging/app_logger.dart';

/// HTTP client for the myFarm mobile app.
///
/// A single [Dio] instance is shared across the app. Interceptors:
/// - Logging interceptor (debug only, never logs bodies containing secrets)
/// - Error mapping interceptor: converts Dio errors into [AppException]
///   subtypes so the repository layer stays HTTP-agnostic.
class ApiClient {
  static Dio? _instance;

  /// Base URL for the backend API. Overridden per environment.
  static String baseUrl = 'http://10.0.2.2:8080/api/v1'; // Android emulator localhost

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor — debug only, redact potential secrets
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            AppLogger.d('${options.method} ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            AppLogger.d('${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          AppLogger.e('Dio error: ${e.message}', stackTrace: e.stackTrace);
          return handler.next(e);
        },
      ),
    );

    return dio;
  }

  /// Maps a [DioException] into a typed [AppException].
  static AppException mapError(Object error, {StackTrace? stackTrace}) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException(cause: error, stackTrace: stackTrace);
        case DioExceptionType.connectionError:
          return NetworkException(cause: error, stackTrace: stackTrace);
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          return ServerException(
            statusCode: statusCode,
            cause: error,
            stackTrace: stackTrace,
          );
        case DioExceptionType.cancel:
          return NetworkException(cause: error, stackTrace: stackTrace);
        case DioExceptionType.unknown:
        default:
          return NetworkException(cause: error, stackTrace: stackTrace);
      }
    }
    return NetworkException(cause: error, stackTrace: stackTrace);
  }
}
