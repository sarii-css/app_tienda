import 'dart:io';
import '../utils/device_utils.dart';

class Config {
  static Future<String> get baseUrl async {
    final isEmulator = await DeviceUtils.isEmulator();

    if (Platform.isAndroid) {
      if (isEmulator) {
        return "http://10.0.2.2:8080"; 
      } else {
        return "http://192.168.0.10:8080"; 
      }
    }

    return "http://localhost:8080";
  }
}