import 'package:flutter/material.dart';

import 'main_page.dart';
import 'favoritos_page.dart';
import 'cesta_page.dart';

import '../models/usuario.dart';
import '../models/producto.dart';

import '../services/usuario_service.dart';
import '../services/api_service.dart';

import 'producto_detalle_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  Usuario? usuario;

  bool cargando = true;

  int paginaActual = 3;

  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();

    cargarUsuario();
    cargarProductos();
  }

  Future<void> cargarUsuario() async {

    try {

      final data =
          await UsuarioService.obtenerUsuario(8);

      setState(() {

        usuario = data;

        cargando = false;
      });

    } catch (e) {

      print("ERROR USUARIO: $e");

      setState(() {

        cargando = false;
      });
    }
  }

  Future<void> cargarProductos() async {

    try {

      final data =
          await ApiService.obtenerProductos();

      setState(() {

        productos = data;
      });

    } catch (e) {

      print("ERROR PRODUCTOS: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF0D0D0D),

      body: SafeArea(

        child: cargando

            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            : SingleChildScrollView(

                child: Column(

                  children: [

                    _header(),

                    _userInfo(),

                    _misDatos(),

                    const Divider(
                      color: Colors.white24,
                    ),

                    _misPedidos(),

                    const Divider(
                      color: Colors.white24,
                    ),

                    _acciones(),

                    const SizedBox(height: 20),

                    _sugerencias(),

                    const SizedBox(height: 10),

                    _productosSugeridos(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
      ),

      // 🔥 NAVIGATION
      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: paginaActual,

        backgroundColor:
            const Color(0xFF111111),

        selectedItemColor: Colors.white,

        unselectedItemColor:
            Colors.white54,

        type:
            BottomNavigationBarType.fixed,

        onTap: (index) {

          if (index == paginaActual) {
            return;
          }

          switch (index) {

            // 🏠 HOME
            case 0:

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const MainPage(),
                ),
              );

              break;

            // ❤️ FAVORITOS
            case 1:

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const FavoritosPage(),
                ),
              );

              break;

            // 🛒 CESTA
            case 2:

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const CestaPage(),
                ),
              );

              break;

            // 👤 PERFIL
            case 3:

              break;
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.shopping_cart),
            label: "Cesta",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  // 🔝 HEADER
  Widget _header() {

    return Padding(

      padding: const EdgeInsets.all(12),

      child: Row(

        children: [

          const CircleAvatar(

            backgroundColor: Colors.white,

            child: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(

            child: TextField(

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(

                hintText: "Buscar",

                hintStyle:
                    const TextStyle(
                  color: Colors.white54,
                ),

                filled: true,

                fillColor: Colors.grey[900],

                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                          30),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Icon(
            Icons.account_circle,
            color: Colors.white70,
            size: 30,
          ),
        ],
      ),
    );
  }

  // 👤 INFO
  Widget _userInfo() {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),

      child: Container(

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: Colors.grey[900],

          borderRadius:
              BorderRadius.circular(20),
        ),

        child: Row(

          children: [

            const CircleAvatar(

              radius: 35,

              backgroundColor:
                  Colors.white24,

              child: Icon(
                Icons.person,
                size: 35,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    usuario?.cliente
                            ?.nombre ??
                        "",

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(

                    usuario?.correo ?? "",

                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(

                    "ID Usuario: ${usuario?.idPK}",

                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            ElevatedButton(

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    Colors.blue,

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
              ),

              onPressed: () {},

              child: const Text(

                "Editar",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 📄 DATOS
  Widget _misDatos() {

    return Padding(

      padding: const EdgeInsets.all(16),

      child: Container(

        width: double.infinity,

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: Colors.grey[850],

          borderRadius:
              BorderRadius.circular(20),
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(

              "Mis datos",

              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _itemDato(
              Icons.person,
              "Nombre",
              usuario?.cliente?.nombre ??
                  "",
            ),

            _itemDato(
              Icons.phone,
              "Teléfono",
              usuario?.cliente?.telefono ??
                  "",
            ),

            _itemDato(
              Icons.male,
              "Género",
              usuario?.cliente?.genero ??
                  "",
            ),

            _itemDato(
              Icons.calendar_month,
              "Nacimiento",
              usuario?.cliente
                      ?.fechaNacimiento
                      ?.toString() ??
                  "",
            ),

            _itemDato(
              Icons.email,
              "Correo",
              usuario?.correo ?? "",
            ),

            _itemDato(

              Icons.location_on,

              "Dirección",

              "${usuario?.cliente?.direccion?.calle ?? ""}, "
              "${usuario?.cliente?.direccion?.colonia ?? ""}, "
              "${usuario?.cliente?.direccion?.municipio ?? ""}, "
              "${usuario?.cliente?.direccion?.estado ?? ""}",
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 ITEM
  Widget _itemDato(
    IconData icono,
    String titulo,
    String valor,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 18,
      ),

      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(
            icono,
            color: Colors.white70,
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  titulo,

                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 3),

                Text(

                  valor,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📦 PEDIDOS
  Widget _misPedidos() {

    return Padding(

      padding: const EdgeInsets.all(16),

      child: Column(

        children: [

          const Align(

            alignment:
                Alignment.centerLeft,

            child: Text(

              "Mis pedidos",

              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceAround,

            children: [

              _iconPedido(
                  Icons.inventory),

              _iconPedido(
                  Icons.card_giftcard),

              _iconPedido(
                  Icons.local_shipping),

              _iconPedido(
                  Icons.shopping_bag),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconPedido(
    IconData icon,
  ) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.grey[900],

        borderRadius:
            BorderRadius.circular(15),
      ),

      child: Icon(
        icon,
        color: Colors.white70,
      ),
    );
  }

  // ⚙️ ACCIONES
  Widget _acciones() {

    return Padding(

      padding: const EdgeInsets.all(16),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,

        children: [

          _accion(Icons.autorenew),

          _accion(
              Icons.support_agent),

          _accion(
              Icons.verified_user),
        ],
      ),
    );
  }

  Widget _accion(
    IconData icono,
  ) {

    return Container(

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(

        color: Colors.grey[900],

        borderRadius:
            BorderRadius.circular(15),
      ),

      child: Icon(
        icono,
        color: Colors.white70,
      ),
    );
  }

  // ⭐ TITULO
  Widget _sugerencias() {

    return const Padding(

      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),

      child: Align(

        alignment:
            Alignment.centerLeft,

        child: Text(

          "También podría gustarte",

          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 🛍 PRODUCTOS REALES
  Widget _productosSugeridos() {

    if (productos.isEmpty) {

      return const Center(

        child: Padding(

          padding: EdgeInsets.all(20),

          child: Text(

            "No hay productos",

            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      );
    }

    return SizedBox(

      height: 280,

      child: ListView.builder(

        scrollDirection:
            Axis.horizontal,

        itemCount: productos.length,

        itemBuilder: (context, index) {

          final p = productos[index];

          return GestureDetector(

            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      ProductoDetallePage(
                    producto: p,
                  ),
                ),
              );
            },

            child: Container(

              width: 180,

              margin:
                  const EdgeInsets.only(
                left: 16,
              ),

              decoration: BoxDecoration(

                color: Colors.grey[900],

                borderRadius:
                    BorderRadius.circular(
                        20),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  ClipRRect(

                    borderRadius:
                        const BorderRadius
                            .vertical(

                      top: Radius.circular(
                          20),
                    ),

                    child: Image.network(

                      "http://192.168.0.6:8080/uploads/${p.imagen}",

                      height: 170,

                      width:
                          double.infinity,

                      fit: BoxFit.cover,

                      errorBuilder:
                          (_, __, ___) {

                        return Container(

                          height: 170,

                          color:
                              Colors.black26,

                          child: const Center(

                            child: Icon(
                              Icons.image,
                              color:
                                  Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(

                    padding:
                        const EdgeInsets
                            .all(12),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(

                          p.nombre,

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              const TextStyle(

                            color:
                                Colors.white,

                            fontSize: 16,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                            height: 6),

                        Text(

                          "\$${p.precio}",

                          style:
                              const TextStyle(

                            color:
                                Colors.green,

                            fontSize: 16,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}