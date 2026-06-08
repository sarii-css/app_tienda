import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cliente.dart';
import '../config.dart';

class ClienteService {

  static String get baseUrl => "${Config.baseUrl}/api";

  static Future<Cliente> obtenerClientePorUsuario(int usuarioId) async {
    final url = Uri.parse("$baseUrl/cliente/usuario/$usuarioId");

    final response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Cliente.fromJson(data);
    } else {
      throw Exception("Error al obtener cliente: ${response.statusCode}");
    }
  }

  static Future<void> actualizarCliente(int id, Map<String, dynamic> cliente) async {
      print("JSON ENVIADO:");
      print(jsonEncode(cliente));

    final response = await http.put(
      Uri.parse("$baseUrl/cliente/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cliente),
    );

    print("UPDATE CLIENTE STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar cliente");
    }
  }
}