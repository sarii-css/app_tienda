import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tienda',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String data = "Cargando...";

  @override
  void initState() {
    super.initState();
    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/productos/productos')
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        data = response.body;
      });
    } else {
      setState(() {
        data = "Error: ${response.statusCode}";
      });
    }
  } catch (e) {
    print(e);
    setState(() {
      data = "Error de conexión";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi tienda 🛒'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}