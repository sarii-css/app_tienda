import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/producto.dart';
import 'producto_page.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

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
            ),

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// 🔝 HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.image, color: Colors.black),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(width: 10),

          const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          )
        ],
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductoPage(
                  categoria: cat["nombre"]!,
                ),
              ),
            );
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
                      "http://10.0.2.2:8080/uploads/${cat["imagen"]}",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
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

        return Padding(
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
                      "http://10.0.2.2:8080/uploads/${p.imagen}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) =>
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
        );
      },
    );
  }

  /// 🔻 BOTTOM BAR
  Widget _buildBottomBar() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home, true),
          _navIcon(Icons.local_offer, false),
          _navIcon(Icons.shopping_cart, false),
          _navIcon(Icons.favorite, false),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, bool active) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: active
          ? BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            )
          : null,
      child: Icon(
        icon,
        color: active ? Colors.white : Colors.grey,
      ),
    );
  }
}