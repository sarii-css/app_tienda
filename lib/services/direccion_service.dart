import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/direccion.dart';
import '../config.dart';

class DireccionService {
  static String get baseUrl => "${Config.baseUrl}/api";

  static Future<Direccion?> obtenerDireccionPorCliente(int clienteId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/direcciones/cliente/$clienteId"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return Direccion.fromJson(data[0]);
        }
      }

      return null;
    } catch (e) {
      print("ERROR DIRECCION: $e");
      return null;
    }
  }

  static Future<void> actualizarDireccion(Direccion direccion) async {
    await http.put(
      Uri.parse("$baseUrl/direccion/${direccion.idPk}"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(direccion.toJson()),
    );
  }

  static Future<void> crearDireccion(Direccion direccion) async {
    await http.post(
      Uri.parse("$baseUrl/direccion"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(direccion.toJson()),
    );
  }
}