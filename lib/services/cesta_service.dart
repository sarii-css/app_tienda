import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cesta.dart';

class CestaService {
  /// 🔥 OJO: SOLO la base (NO repitas rutas)
  static const String baseUrl = "http://192.168.0.10:8080/api";

  /// 🔹 Obtener TODA la cesta
  static Future<List<Cesta>> obtenerCesta() async {
    final response = await http.get(
      Uri.parse("$baseUrl/cesta"),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Cesta.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener cesta");
    }
  }

  /// 🔹 Obtener cesta por usuario
  static Future<List<Cesta>> obtenerCestaPorUsuario(int usuarioId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/cesta/usuario/$usuarioId"),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Cesta.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener cesta por usuario");
    }
  }

  /// 🔹 Guardar en cesta (AGREGAR)
  static Future<void> guardarCesta(int usuarioId, int productoId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cesta"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario": {"idPK": usuarioId},
        "producto": {"idPK": productoId}
      }),
    );

    print("STATUS POST: ${response.statusCode}");
    print("BODY POST: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al guardar en cesta");
    }
  }

  /// 🔹 Eliminar de cesta
  static Future<void> eliminarCesta(int usuarioId, int productoId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/cesta/eliminar/$usuarioId/$productoId"),
    );

    print("STATUS DELETE: ${response.statusCode}");

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar de cesta");
    }
  }
}