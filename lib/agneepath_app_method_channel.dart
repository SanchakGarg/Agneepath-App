import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'agneepath_app_platform_interface.dart';

/// An implementation of [AgneepathAppPlatform] that uses method channels.
class MethodChannelAgneepathApp extends AgneepathAppPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('agneepath_app');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
