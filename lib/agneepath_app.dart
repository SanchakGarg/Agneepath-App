
import 'agneepath_app_platform_interface.dart';

class AgneepathApp {
  Future<String?> getPlatformVersion() {
    return AgneepathAppPlatform.instance.getPlatformVersion();
  }
}
