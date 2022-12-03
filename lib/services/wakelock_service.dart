import 'package:wakelock/wakelock.dart';
import 'package:flutter/foundation.dart';

class WakeLockService {
  WakeLockService._privateConstructor();

  static final WakeLockService instance = WakeLockService._privateConstructor();

  void lockIf(bool condition) {
    if (condition) {
      Wakelock.enable();
    }
  }

  void lockDebug() {
    lockIf(kDebugMode);
  }

  void unlock() {
    Wakelock.disable();
  }
}
