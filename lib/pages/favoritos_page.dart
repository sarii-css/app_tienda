import 'package:flutter/material.dart';
import '../services/favorito_service.dart';
import '../services/cesta_service.dart';
import '../models/favorito.dart';


class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  List<Favorito> favoritos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarFavoritos();
  }

  Future<void> cargarFavoritos() async {
    try {
      final data = await FavoritoService.obtenerFavoritosPorUsuario(1);

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
    return Container(
      color: const Color(0xFF0D0D0D),

      child: Column(
        children: [
          const SizedBox(height: 10),

          const Text(
            "Favoritos",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : favoritos.isEmpty
                    ? const Center(
                        child: Text(
                          "No tienes favoritos",
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: cargarFavoritos,
                        child: ListView.builder(
                          itemCount: favoritos.length,
                          itemBuilder: (context, index) {
                            final fav = favoritos[index];
                            return _cardFavorito(fav);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  /// CARD
  Widget _cardFavorito(Favorito fav) {
    final p = fav.producto;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            /// IMAGEN
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: Image.network(
                "http://192.168.0.6:8080/uploads/${p.imagen}",
                width: 100,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image, color: Colors.white),
              ),
            ),

            /// INFO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// nombre + eliminar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            p.nombre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                            await FavoritoService.eliminarFavorito(
                                fav.usuario.idPK, p.id);

                            setState(() {
                              favoritos.remove(fav);
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    /// DESCRIPCIÓN REAL
                    Text(
                      p.descripcion,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    /// PRECIO + BOTÓN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${p.precio}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                            try {
                              await CestaService.guardarCesta(
                                fav.usuario.idPK,
                                p.id,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Agregado a la cesta"),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Error al agregar"),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "Agregar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}