import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/producto.dart';
import 'producto_detalle_page.dart';

class HomePage extends StatefulWidget {
  final Function(String) onCategoriaTap;

  const HomePage({super.key, required this.onCategoriaTap});

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
      setState(() {
        productos = data;
        cargando = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),

      child: cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text("Categorías",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),

                  _buildCategorias(),

                  _buildMiniMenu(),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text("Nuestra selección para ti",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),

                  _buildProductos(),
                ],
              ),
            ),
    );
  }

  /// 🧩 CATEGORÍAS
  Widget _buildCategorias() {
    final categorias = [
      {"nombre": "Playera", "imagen": "playera.png"},
      {"nombre": "Hoodie", "imagen": "sudadera.png"},
      {"nombre": "Otro", "imagen": "otros.png"},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final cat = categorias[index];

          return GestureDetector(
            onTap: () {
              widget.onCategoriaTap(cat["nombre"]!);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "http://192.168.0.6:8080/uploads/${cat["imagen"]}",
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.image, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat["nombre"]!,
                    style: const TextStyle(color: Colors.white70),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔘 MINI MENÚ
  Widget _buildMiniMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.phone_in_talk, color: Colors.white54),
          Icon(Icons.attach_money_outlined, color: Colors.white54),
          Icon(Icons.local_shipping, color: Colors.white54),
        ],
      ),
    );
  }

  /// 🛍️ PRODUCTOS
  Widget _buildProductos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final p = productos[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductoDetallePage(producto: p),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
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
                        "http://192.168.0.6:8080/uploads/${p.imagen}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.image, color: Colors.white),
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
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}