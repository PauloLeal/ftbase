import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseCrashlyticsService {
  FirebaseCrashlyticsService._privateConstructor();
  static final FirebaseCrashlyticsService instance = FirebaseCrashlyticsService._privateConstructor();

  Future<void> initialize() async {
    return _config(true);
  }

  Future<void> disableIf(bool condition) async {
    _config(!condition);
  }

  Future<void> enableIf(bool condition) async {
    _config(condition);
  }

  Future<void> _config(bool condition) async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(condition);
  }

  /// Causes the app to crash (natively).
  void crash() {
    FirebaseCrashlytics.instance.crash();
  }
}
