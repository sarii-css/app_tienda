import 'package:flutter/material.dart';
import '../services/favorito_service.dart';
import '../services/cesta_service.dart';
import '../models/favorito.dart';
import 'producto_detalle_page.dart';
import '../services/session.dart';
import '../widgets/guest_view.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  List<Favorito> favoritos = [];
  bool cargando = true;

  int get usuarioId => Session.userId!;

  @override
  void initState() {
    super.initState();

    if (!Session.isGuest && Session.userId != null) {
      cargarFavoritos();
    } else {
      cargando = false;
    }
  }

  Future<void> cargarFavoritos() async {
    try {
      final data =
          await FavoritoService.obtenerFavoritosPorUsuario(usuarioId);

      setState(() {
        favoritos = data;
        cargando = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Session.isGuest || Session.userId == null) {
      return const Scaffold(
        body: GuestView(
          mensaje: "Inicia sesión para ver tus favoritos",
        ),
      );
    }

    return Container(
      color: const Color(0xFF0D0D0D),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Favoritos",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : favoritos.isEmpty
                    ? const Center(
                        child: Text("No tienes favoritos",
                            style: TextStyle(color: Colors.white54)))
                    : RefreshIndicator(
                        onRefresh: cargarFavoritos,
                        child: ListView.builder(
                          itemCount: favoritos.length,
                          itemBuilder: (context, index) {
                            return _cardFavorito(favoritos[index]);
                          },
                        ),
                      ),
          )
        ],
      ),
    );
  }

  Widget _cardFavorito(Favorito fav) {
    final p = fav.producto;
    bool cargandoCesta = false;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(20)),
                    child: Image.network(
                      "http://192.168.0.6:8080/uploads/${p.imagen}",
                      width: 100,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(p.nombre,
                                    style: const TextStyle(
                                        color: Colors.white),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite,
                                    color: Colors.red),
                                onPressed: () async {
                                  await FavoritoService.eliminarFavorito(
                                      usuarioId, p.id);

                                  setState(() {
                                    favoritos.remove(fav);
                                  });
                                },
                              )
                            ],
                          ),

                          const Spacer(),

                          GestureDetector(
                            onTap: cargandoCesta
                                ? null
                                : () async {
                                    setLocalState(
                                        () => cargandoCesta = true);

                                    try {
                                      await CestaService.guardarCesta(
                                          usuarioId, p.id);

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text("Agregado a la cesta"),
                                      ));
                                    } catch (e) {
                                      print(e);
                                    }

                                    if (mounted) {
                                      setLocalState(
                                          () => cargandoCesta = false);
                                    }
                                  },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text("Agregar a cesta",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      ),
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