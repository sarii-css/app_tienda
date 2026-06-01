import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/favorito.dart';
import '../config.dart';

class FavoritoService {
  static String get baseUrl => "${Config.baseUrl}/api";

  static Future<List<Favorito>> obtenerFavoritosPorUsuario(int usuarioId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/favoritos/usuario/$usuarioId"),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Favorito.fromJson(e)).toList();
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  static Future<void> eliminarFavorito(int usuarioId, int productoId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/favoritos/eliminar/$usuarioId/$productoId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar favorito");
    }
  }

  static Future<void> guardarFavorito(int usuarioId, int productoId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/favoritos"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario": {"idPK": usuarioId},  
        "producto": {"idPK": productoId}  
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al guardar favorito");
    }
  }
}