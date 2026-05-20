import 'package:shared_preferences/shared_preferences.dart';
import '../services/session.dart';

class SessionStorage {

  static Future<void> guardarSesion() async {
    final prefs = await SharedPreferences.getInstance();

    if (Session.userId != null) {
      await prefs.setInt("userId", Session.userId!);
    }

    if (Session.nombre != null) {
      await prefs.setString("nombre", Session.nombre!);
    }

    if (Session.correo != null) {
      await prefs.setString("correo", Session.correo!);
    }
  }

  static Future<void> cargarSesion() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt("userId");

    if (userId != null) {
      Session.userId = userId;
      Session.nombre = prefs.getString("nombre");
      Session.correo = prefs.getString("correo");
      Session.isGuest = false;
    }
  }

  static Future<void> limpiarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}