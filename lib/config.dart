import 'dart:io';

class Config {
  static String get baseUrl {
    if (Platform.isAndroid) {
      // camiar entre ip (test en celular) & "http://10.0.2.2:8080" (test en emulador)
      return "http://192.168.0.10:8080";
    } else {
      return "http://localhost:8080";
    }
  }
}