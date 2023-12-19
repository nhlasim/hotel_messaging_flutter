import 'package:logger/logger.dart';

class AppLog {

  static final _logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
      printTime: true,
    )
  );

  static void d(String className, {String? methodName, required String message}) {
    _logger.d('$className: (method: $methodName) $message');
  }

  static void e(dynamic error, String className, {String? methodName, required String message}) {
    _logger.e('$className: (method: $methodName) $message', error);
  }
}