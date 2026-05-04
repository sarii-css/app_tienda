import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';

class ProductoPage extends StatefulWidget {
  final String categoria;

  const ProductoPage({super.key, required this.categoria});

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
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

      // 🔥 FILTRAR POR CATEGORÍA
      final filtrados = data
          .where((p) => p.categoria == widget.categoria)
          .toList();

      setState(() {
        productos = filtrados;
        cargando = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.categoria,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: productos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final p = productos[index];

                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: Image.network(
                            "http://10.0.2.2:8080/uploads/${p.imagen}",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(
                              p.nombre,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${p.precio}",
                              style: const TextStyle(
                                color: Color(0xFF6F84A7),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}