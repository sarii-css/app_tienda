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
  
  static Future<void> actualizarCliente(Cliente c) async {
  final response = await http.put(
    Uri.parse("$baseUrl/cliente/${c.idPk}"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(c.toJson()),
  );

  print("CLIENTE UPDATE STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Error al actualizar cliente");
  }
}
}