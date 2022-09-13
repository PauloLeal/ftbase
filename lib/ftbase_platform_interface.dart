import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ftbase_method_channel.dart';

abstract class FtbasePlatform extends PlatformInterface {
  /// Constructs a FtbasePlatform.
  FtbasePlatform() : super(token: _token);

  static final Object _token = Object();

  static FtbasePlatform _instance = MethodChannelFtbase();

  /// The default instance of [FtbasePlatform] to use.
  ///
  /// Defaults to [MethodChannelFtbase].
  static FtbasePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FtbasePlatform] when
  /// they register themselves.
  static set instance(FtbasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
