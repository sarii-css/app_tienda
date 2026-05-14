import 'package:flutter/material.dart';
import '../services/cesta_service.dart';
import '../services/api_service.dart';
import '../models/cesta.dart';
import '../models/producto.dart';
import 'producto_detalle_page.dart';
import '../services/session.dart';
import '../widgets/guest_view.dart';

class CestaPage extends StatefulWidget {
  const CestaPage({super.key});

  @override
  State<CestaPage> createState() => _CestaPageState();
}

class _CestaPageState extends State<CestaPage> {
  List<Cesta> cesta = [];
  List<Producto> sugerencias = [];

  bool cargando = true;

  int get usuarioId => Session.userId!;

  @override
  void initState() {
    super.initState();

    if (!Session.isGuest && Session.userId != null) {
      cargarTodo();
    } else {
      cargando = false;
    }
  }

  Future<void> cargarTodo() async {
    try {
      final data =
          await CestaService.obtenerCestaPorUsuario(usuarioId);
      final prod = await ApiService.obtenerProductos();

      setState(() {
        cesta = data;
        sugerencias = prod;
        cargando = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() => cargando = false);
    }
  }

  double get total =>
      cesta.fold(0, (sum, item) => sum + item.producto.precio);

  @override
  Widget build(BuildContext context) {
    if (Session.isGuest || Session.userId == null) {
      return const Scaffold(
        body: GuestView(
          mensaje: "Inicia sesión para ver tu cesta",
        ),
      );
    }

    return Container(
      color: const Color(0xFF0D0D0D),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Cesta",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          Expanded(
            child: RefreshIndicator(
              onRefresh: cargarTodo,
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        if (cesta.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                "Tu carrito está vacío",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                          )
                        else
                          ...cesta.map((item) => _cardCesta(item)),

                        const SizedBox(height: 20),

                        if (sugerencias.isNotEmpty) _sugerencias(),
                      ],
                    ),
            ),
          ),

          if (cesta.isNotEmpty) _totalSection(),
        ],
      ),
    );
  }

  Widget _cardCesta(Cesta item) {
    final p = item.producto;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductoDetallePage(producto: p),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  "http://192.168.0.6:8080/uploads/${p.imagen}",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.image, color: Colors.white),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      p.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "\$${p.precio}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () async {
                  await CestaService.eliminarCesta(
                    item.usuario.idPK,
                    p.id,
                  );

                  setState(() {
                    cesta.remove(item);
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sugerencias() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "También podría gustarte",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sugerencias.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              final p = sugerencias[index];

              return Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductoDetallePage(producto: p),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                            child: Image.network(
                              "http://192.168.0.6:8080/uploads/${p.imagen}",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            children: [
                              Text(
                                p.nombre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "\$${p.precio}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _totalSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.black,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total",
                  style: TextStyle(color: Colors.white)),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Compra realizada")),
              );
            },
            child: const Text(
              "Comprar",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}