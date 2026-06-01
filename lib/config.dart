import 'dart:io';

class Config {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8080";
    } else {
      return "http://192.168.0.10:8080";
    }
  }
}