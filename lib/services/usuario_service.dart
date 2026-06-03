import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../config.dart';

class UsuarioService {

static String get baseUrl =>
  "${Config.baseUrl}/usuarios";

  static Future<Usuario> obtenerUsuario(int id) async {

    final url = Uri.parse("$baseUrl/$id");

    final response = await http.get(url);

    print("================================");
    print("OBTENER USUARIO");
    print("URL: $url");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("================================");

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      print("JSON DECODIFICADO:");
      print(data);

      return Usuario.fromJson(data);

    } else {

      throw Exception(
        "Error al obtener usuario: ${response.body}",
      );
    }
  }

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

  static Future<Usuario> crearUsuario(
    String nombre,
    String correo,
    String contrasena,
  ) async {

    final url = Uri.parse("$baseUrl/registrar");

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
  
  static Future<void> actualizarUsuario(Usuario user) async {
  final response = await http.put(
    Uri.parse("$baseUrl/${user.idPK}"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "nombreusuario": user.nombreusuario,
      "correo": user.correo,
      "contrasena": user.contrasena,
    }),
  );

  print("USUARIO UPDATE STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Error al actualizar usuario");
  }
}
}