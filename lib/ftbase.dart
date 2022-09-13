
import 'ftbase_platform_interface.dart';

class Ftbase {
  Future<String?> getPlatformVersion() {
    return FtbasePlatform.instance.getPlatformVersion();
  }
}
