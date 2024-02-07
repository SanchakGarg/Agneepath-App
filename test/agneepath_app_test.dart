import 'package:flutter_test/flutter_test.dart';
import 'package:agneepath_app/agneepath_app.dart';
import 'package:agneepath_app/agneepath_app_platform_interface.dart';
import 'package:agneepath_app/agneepath_app_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAgneepathAppPlatform
    with MockPlatformInterfaceMixin
    implements AgneepathAppPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AgneepathAppPlatform initialPlatform = AgneepathAppPlatform.instance;

  test('$MethodChannelAgneepathApp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAgneepathApp>());
  });

  test('getPlatformVersion', () async {
    AgneepathApp agneepathAppPlugin = AgneepathApp();
    MockAgneepathAppPlatform fakePlatform = MockAgneepathAppPlatform();
    AgneepathAppPlatform.instance = fakePlatform;

    expect(await agneepathAppPlugin.getPlatformVersion(), '42');
  });
}
