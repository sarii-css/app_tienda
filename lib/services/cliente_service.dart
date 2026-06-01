import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cliente.dart';
import '../config.dart';

class ClienteService {

 static String get baseUrl => "${Config.baseUrl}/api";

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