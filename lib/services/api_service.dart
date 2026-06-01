import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../models/review.dart';
import '../config.dart';

class ApiService {
  static String get baseUrl =>
  "${Config.baseUrl}";

  static Future<List<Producto>> obtenerProductos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/productos/productos'),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Producto.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  static Future<List<Review>> obtenerReviews(int productoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/resenas/producto/$productoId'),
    );

    print("REVIEWS BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((r) {
        final resena = r["resena"] ?? r;

        return Review(
          usuario:
              resena["usuario"]?["nombreusuario"] ?? "Usuario",
          rating: int.parse(resena["calificacion"].toString()),
          comentario: resena["comentario"] ?? "",
        );
      }).toList();
    } else {
      throw Exception("Error cargando reviews");
    }
  }
}