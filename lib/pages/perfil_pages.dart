import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../models/producto.dart';
import '../models/cliente.dart';

import '../services/usuario_service.dart';
import '../services/api_service.dart';
import '../services/cliente_service.dart';
import '../services/session.dart';

import 'producto_detalle_page.dart';

import '../storage/session_storage.dart';
import '../widgets/guest_view.dart';
import 'editar_perfil_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  Usuario? usuario;
  Cliente? cliente;

  bool cargando = true;

  List<Producto> productos = [];

 @override
void initState() {
  super.initState();

  if (!Session.isGuest && Session.userId != null) {
    cargarUsuario();
    cargarCliente();
  }

  cargarProductos();
}

  Future<void> cargarUsuario() async {
  try {
    if (Session.userId == null) return;

    final data = await UsuarioService.obtenerUsuario(Session.userId!);

    setState(() {
      usuario = data;
    });

  } catch (e) {
    print("ERROR USUARIO: $e");
  }
}

 Future<void> cargarCliente() async {
  try {
    if (Session.userId == null) return;

    final data = await ClienteService.obtenerClientePorUsuario(Session.userId!);

    setState(() {
      cliente = data;
    });

  } catch (e) {
    print("ERROR CLIENTE: $e");
  }
}

  Future<void> cargarProductos() async {
    try {
      final data = await ApiService.obtenerProductos();

      setState(() {
        productos = data;
        cargando = false;
      });

    } catch (e) {
      print("ERROR PRODUCTOS: $e");
      setState(() {
        cargando = false;
      });
    }
  }

  Future<void> logout() async {
  await SessionStorage.limpiarSesion();
  Session.clear();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const GuestView(
        mensaje: "Inicia sesión para continuar",
      ),
    ),
    (route) => false,
  );
}

  @override
Widget build(BuildContext context) {

  if (Session.isGuest || Session.userId == null) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D0D0D),
      body: Center(
        child: Text(
          "Inicia sesión para ver tu perfil",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  if (cargando || cliente == null) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D0D0D),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  return Scaffold(
    backgroundColor: const Color(0xFF0D0D0D),

    body: SingleChildScrollView(
      child: Column(
        children: [

          _userInfo(),
          _misDatos(),

          const Divider(color: Colors.white24),

          _misPedidos(),

          const Divider(color: Colors.white24),

          _acciones(),

          const SizedBox(height: 20),

          _sugerencias(),

          const SizedBox(height: 10),

          _productosSugeridos(),

          const SizedBox(height: 100),
        ],
      ),
    ),
  );
}

  // 👤 INFO
  Widget _userInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          children: [

            const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 35, color: Colors.white),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    cliente?.nombre ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
  onPressed: () async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarPerfilPage(
          usuario: usuario!,
          cliente: cliente!,
        ),
      ),
    );

    cargarUsuario();
    cargarCliente();
  },
  child: const Text("Editar"),
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
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Mis datos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _itemDato(Icons.person, "Nombre", cliente?.nombre ?? ""),
            _itemDato(Icons.phone, "Teléfono", cliente?.telefono ?? ""),
            _itemDato(Icons.male, "Género", cliente?.genero ?? ""),
            _itemDato(Icons.calendar_month, "Nacimiento",
                cliente?.fechaNacimiento ?? ""),
            _itemDato(Icons.email, "Correo", usuario?.correo ?? ""),

            _itemDato(
              Icons.location_on,
              "Dirección",
              "${cliente?.direccion.calle ?? ""}, "
              "${cliente?.direccion.colonia ?? ""}, "
              "${cliente?.direccion.municipio ?? ""}, "
              "${cliente?.direccion.estado ?? ""}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemDato(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(icono, color: Colors.white70, size: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

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
            alignment: Alignment.centerLeft,
            child: Text(
              "Mis pedidos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _iconPedido(Icons.inventory),
              _iconPedido(Icons.card_giftcard),
              _iconPedido(Icons.local_shipping),
              _iconPedido(Icons.shopping_bag),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconPedido(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Colors.white70),
    );
  }

  // ⚙️ ACCIONES
  Widget _acciones() {
  return Padding(
    padding: const EdgeInsets.all(16),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _accion(Icons.autorenew),
        _accion(Icons.support_agent),
        _accion(Icons.verified_user),

        GestureDetector(
          onTap: logout,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red[900],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.logout, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

  Widget _accion(IconData icono) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icono, color: Colors.white70),
    );
  }

  // ⭐ TITULO
  Widget _sugerencias() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "También podría gustarte",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 🛍 PRODUCTOS
  Widget _productosSugeridos() {

    if (productos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No hay productos",
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return SizedBox(
      height: 280,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productos.length,

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
              width: 180,
              margin: const EdgeInsets.only(left: 16),

              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),

                    child: Image.network(
                      "http://192.168.0.10:8080/uploads/${p.imagen}",
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,

                      errorBuilder: (_, _, _) {
                        return Container(
                          height: 170,
                          color: Colors.black26,
                          child: const Center(
                            child: Icon(Icons.image, color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          p.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "\$${p.precio}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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