part of ftbase;

class Log {
  Log._privateConstructor();

  static final Log _instance = Log._privateConstructor();

  static Log get instance => _instance;

  void _log(String type, dynamic message) {
    DateTime now = DateTime.now();
    String ns = now.toIso8601String();
    dev.log("[$type][$ns] $message");
  }

  static void trace(dynamic message) => _instance._log("TRACE", message);
  static void debug(dynamic message) => _instance._log("DEBUG", message);
  static void info(dynamic message) => _instance._log("INFO", message);
  static void warn(dynamic message) => _instance._log("WARN", message);
  static void error(dynamic message) => _instance._log("ERROR", message);
}
