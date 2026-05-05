import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';
import 'producto_detalle_page.dart';

class ProductoPage extends StatefulWidget {
  final String? categoriaInicial;
  final String search;

  const ProductoPage({
    super.key,
    this.categoriaInicial,
    required this.search,
  });

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  List<Producto> data = [];
  String categoriaSeleccionada = "todos";
  String filtroSeleccionado = "todos";
  bool loading = true;

  final categorias = ["todos", "hoodies", "playeras", "accesorios"];
  final filtros = ["todos", "nuevo", "oferta", "popular"];

  @override
  void initState() {
    super.initState();
    cargarProductos();

    if (widget.categoriaInicial != null) {
      categoriaSeleccionada = widget.categoriaInicial!;
    }
  }

  Future<void> cargarProductos() async {
    try {
      final productos = await ApiService.obtenerProductos();

      setState(() {
        data = productos;
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = data.where((p) {
      final matchCategoria = categoriaSeleccionada == "todos"
          ? true
          : p.categoria.toLowerCase() ==
              categoriaSeleccionada.toLowerCase();

      final matchFiltro = filtroSeleccionado == "todos"
          ? true
          : p.descripcion.toLowerCase().contains(filtroSeleccionado);

      final matchSearch = widget.search.isEmpty
          ? true
          : p.nombre.toLowerCase().contains(widget.search.toLowerCase()) ||
              p.descripcion.toLowerCase().contains(widget.search.toLowerCase());

      return matchCategoria && matchFiltro && matchSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 CATEGORÍAS
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categorias.length,
            itemBuilder: (context, i) {
              final cat = categorias[i];
              final selected = cat == categoriaSeleccionada;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    categoriaSeleccionada = cat;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      cat.toUpperCase(),
                      style: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // 🔥 FILTROS
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filtros.length,
            itemBuilder: (context, i) {
              final fil = filtros[i];
              final selected = fil == filtroSeleccionado;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    filtroSeleccionado = fil;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? Colors.grey[700] : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      fil,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // 🔥 LISTA
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : filtrados.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay productos 😢",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: filtrados.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, i) {
                        final producto = filtrados[i];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductoDetallePage(
                                  producto: producto,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🖼️ IMAGEN
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    child: Image.network(
                                      "http://10.0.2.2:8080/uploads/${producto.imagen}",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // 📝 INFO
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        producto.nombre,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "\$${producto.precio}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
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
    );
  }
}