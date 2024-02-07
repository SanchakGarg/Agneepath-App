import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'agneepath_app_method_channel.dart';

abstract class AgneepathAppPlatform extends PlatformInterface {
  /// Constructs a AgneepathAppPlatform.
  AgneepathAppPlatform() : super(token: _token);

  static final Object _token = Object();

  static AgneepathAppPlatform _instance = MethodChannelAgneepathApp();

  /// The default instance of [AgneepathAppPlatform] to use.
  ///
  /// Defaults to [MethodChannelAgneepathApp].
  static AgneepathAppPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AgneepathAppPlatform] when
  /// they register themselves.
  static set instance(AgneepathAppPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
