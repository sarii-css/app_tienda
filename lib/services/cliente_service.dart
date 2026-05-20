import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cliente.dart';

class ClienteService {

  static const String baseUrl = "http://192.168.0.10:8080/api";

  // 🔍 Obtener cliente por usuario
  static Future<Cliente> obtenerClientePorUsuario(int usuarioId) async {

    final url = Uri.parse("$baseUrl/cliente/usuario/$usuarioId");

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return Cliente.fromJson(data);

    } else {

      throw Exception("Error al obtener cliente: ${response.statusCode}");

    }
  }
}