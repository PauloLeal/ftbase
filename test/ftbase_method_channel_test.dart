import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ftbase/ftbase_method_channel.dart';

void main() {
  MethodChannelFtbase platform = MethodChannelFtbase();
  const MethodChannel channel = MethodChannel('ftbase');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
