import 'package:flutter_test/flutter_test.dart';
import 'package:ftbase/ftbase.dart';
import 'package:ftbase/ftbase_platform_interface.dart';
import 'package:ftbase/ftbase_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFtbasePlatform
    with MockPlatformInterfaceMixin
    implements FtbasePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FtbasePlatform initialPlatform = FtbasePlatform.instance;

  test('$MethodChannelFtbase is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFtbase>());
  });

  test('getPlatformVersion', () async {
    Ftbase ftbasePlugin = Ftbase();
    MockFtbasePlatform fakePlatform = MockFtbasePlatform();
    FtbasePlatform.instance = fakePlatform;

    expect(await ftbasePlugin.getPlatformVersion(), '42');
  });
}
