import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ftbase_platform_interface.dart';

/// An implementation of [FtbasePlatform] that uses method channels.
class MethodChannelFtbase extends FtbasePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ftbase');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
