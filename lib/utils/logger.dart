import 'dart:developer';

import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  // Chỉ log khi ở chế độ Debug
  static void debug(String message) => _logger.d(message);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  static void info(String message) => _logger.i(message);
  //logd from develop
  static void logD(String message) => log(message);
}
