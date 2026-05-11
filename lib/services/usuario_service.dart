import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {

  // 🔥 URL BASE
  static const String baseUrl =
      "http://192.168.0.6:8080/usuarios";

  // ==========================
  // 🔍 OBTENER USUARIO POR ID
  // ==========================
  static Future<Usuario> obtenerUsuario(int id) async {

    final url = Uri.parse("$baseUrl/$id");

    final response = await http.get(url);

    // 🔥 DEBUG
    print("================================");
    print("OBTENER USUARIO");
    print("URL: $url");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("================================");

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      // 🔥 VER JSON COMPLETO
      print("JSON DECODIFICADO:");
      print(data);

      return Usuario.fromJson(data);

    } else {

      throw Exception(
        "Error al obtener usuario: ${response.body}",
      );
    }
  }

  // ==========================
  // 📋 LISTAR USUARIOS
  // ==========================
  static Future<List<Usuario>> obtenerUsuarios() async {

    final url = Uri.parse(baseUrl);

    final response = await http.get(url);

    print("================================");
    print("LISTAR USUARIOS");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("================================");

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      return data
          .map((json) => Usuario.fromJson(json))
          .toList();

    } else {

      throw Exception("Error al obtener usuarios");
    }
  }

  // ==========================
  // 🔐 LOGIN
  // ==========================
  static Future<Usuario> login(
    String correo,
    String contrasena,
  ) async {

    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(

      url,

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "correo": correo,

        "contrasena": contrasena,
      }),
    );

    print("================================");
    print("LOGIN");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("================================");

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return Usuario.fromJson(data);

    } else {

      throw Exception(
        "Error en login: ${response.body}",
      );
    }
  }

  // ==========================
  // 📝 CREAR USUARIO
  // ==========================
  static Future<Usuario> crearUsuario(
    String nombre,
    String correo,
    String contrasena,
  ) async {

    final url = Uri.parse(baseUrl);

    final response = await http.post(

      url,

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "nombreusuario": nombre,

        "correo": correo,

        "contrasena": contrasena,
      }),
    );

    print("================================");
    print("CREAR USUARIO");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("================================");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      final data = jsonDecode(response.body);

      return Usuario.fromJson(data);

    } else {

      throw Exception(
        "Error al registrar usuario",
      );
    }
  }

  // ==========================
  // ✏️ ACTUALIZAR NOMBRE
  // ==========================
  static Future<Usuario> actualizarNombre(
    int id,
    String nuevoNombre,
  ) async {

    final url = Uri.parse("$baseUrl/$id");

    final response = await http.put(

      url,

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "nombreusuario": nuevoNombre,
      }),
    );

    print("================================");
    print("ACTUALIZAR USUARIO");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("================================");

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return Usuario.fromJson(data);

    } else {

      throw Exception(
        "Error al actualizar usuario",
      );
    }
  }

  // ==========================
  // ❌ ELIMINAR USUARIO
  // ==========================
  static Future<bool> eliminarUsuario(int id) async {

    final url = Uri.parse("$baseUrl/$id");

    final response = await http.delete(url);

    print("================================");
    print("ELIMINAR USUARIO");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("================================");

    return response.statusCode == 200;
  }
}