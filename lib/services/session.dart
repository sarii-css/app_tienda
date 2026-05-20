class Session { 
  static bool isGuest = true; 

  static int? userId; 
  static String? nombre; 
  static String? correo; 

  static void clear() { 
    isGuest = true; 
    userId = null; 
    nombre = null; 
    correo = null; 
  } 
}