import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtils {
  static Future<bool> isEmulator() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return !androidInfo.isPhysicalDevice;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    }

    return false;
  }
}