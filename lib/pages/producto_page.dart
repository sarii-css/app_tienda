import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';
import 'producto_detalle_page.dart';

class ProductoPage extends StatefulWidget {
  final String? categoriaInicial;

  const ProductoPage({super.key, this.categoriaInicial});

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  List<Producto> productos = [];
  bool cargando = true;

  String categoriaSeleccionada = "todos";
  String filtroSeleccionado = "todos";

  final categorias = ["todos", "Playera", "Hoodie", "Otro"];
  final filtros = ["todos", "manga larga", "manga corta", "oversize"];

  @override
  void initState() {
    super.initState();

    if (widget.categoriaInicial != null) {
      categoriaSeleccionada = widget.categoriaInicial!;
    }

    cargarProductos();
  }

  Future<void> cargarProductos() async {
    try {
      final data = await ApiService.obtenerProductos();

      final filtrados = data.where((p) {
        final matchCategoria = categoriaSeleccionada == "todos"
            ? true
            : p.categoria.toLowerCase() ==
                categoriaSeleccionada.toLowerCase();

        final matchFiltro = filtroSeleccionado == "todos"
            ? true
            : p.descripcion
                .toLowerCase()
                .contains(filtroSeleccionado);

        return matchCategoria && matchFiltro;
      }).toList();

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

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            // 🔥 CATEGORÍAS
            _buildCategorias(),

            const SizedBox(height: 10),

            // 🔥 FILTROS
            _buildFiltros(),

            const SizedBox(height: 10),

            // 🔥 GRID
            Expanded(
  child: cargando
      ? const Center(child: CircularProgressIndicator())
      : GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: productos.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
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
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(
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
                            style: const TextStyle(
                                color: Colors.white),
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
              ),
            );
          },
        ),
)
          ],
        ),
      ),
    );
  }

  /// 🔥 CATEGORÍAS
  Widget _buildCategorias() {
  final categoriasData = [
    {"nombre": "todos", "imagen": "todos.png"},
    {"nombre": "Playera", "imagen": "playera.png"},
    {"nombre": "Hoodie", "imagen": "sudadera.png"},
    {"nombre": "Otro", "imagen": "otros.png"},
  ];

  return SizedBox(
    height: 110,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categoriasData.length,
      itemBuilder: (context, index) {
        final cat = categoriasData[index];
        final nombre = cat["nombre"]!;
        final seleccionada = categoriaSeleccionada == nombre;

        return GestureDetector(
          onTap: () {
            setState(() {
              categoriaSeleccionada = nombre;
              cargando = true;
            });
            cargarProductos();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: seleccionada
                        ? const Color(0xFF6F84A7)
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                    border: seleccionada
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
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
                  nombre,
                  style: TextStyle(
                    color: seleccionada
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: seleccionada
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
        );
      },
    ),
  );
}

  /// 🔥 FILTROS
  Widget _buildFiltros() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filtros.length,
        itemBuilder: (context, index) {
          final f = filtros[index];
          final seleccionado = filtroSeleccionado == f;

          return GestureDetector(
            onTap: () {
              setState(() {
                filtroSeleccionado = f;
                cargando = true;
              });
              cargarProductos();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: seleccionado
                    ? const Color(0xFF6F84A7)
                    : Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  f,
                  style: TextStyle(
                    color: seleccionado
                        ? Colors.white
                        : Colors.white70,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}