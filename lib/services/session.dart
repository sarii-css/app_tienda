class Session {
  static bool isGuest = false;

  static int? userId;
  static String? nombre;
  static String? correo;

  static void clear() {
    isGuest = false;
    userId = null;
    nombre = null;
    correo = null;
  }
}