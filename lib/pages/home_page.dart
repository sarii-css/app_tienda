import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/producto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Producto> productos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    try {
      final data = await ApiService.obtenerProductos();
      print("DATOS: $data");
      setState(() {
        productos = data;
        cargando = false;
      });
    } catch (e) {
      print("ERROR: $e"); // 👈 agregado
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi tienda 🛒'),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final p = productos[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(p.nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.descripcion),
                        Text('Color: ${p.color}'),
                        Text('Talla: ${p.talla}'),
                        Text('Categoría: ${p.categoria}'),
                        Text('Precio: \$${p.precio}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}