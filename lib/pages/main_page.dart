import 'package:flutter/material.dart';

import 'home_page.dart';
import 'producto_page.dart';
import 'cesta_page.dart';
import 'favoritos_page.dart';
import 'perfil_pages.dart';
import '../widgets/custom_header.dart';

class MainPage extends StatefulWidget {
  final String? categoriaInicial;

  const MainPage({super.key, this.categoriaInicial});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  String? categoriaSeleccionada;
  String searchText = "";

  @override
  void initState() {
    super.initState();

    if (widget.categoriaInicial != null) {
      index = 1;
      categoriaSeleccionada = widget.categoriaInicial;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onCategoriaTap: (cat) {
          setState(() {
            index = 1;
            categoriaSeleccionada = cat;
          });
        },
      ),

      ProductoPage(
        key: ValueKey(
          "${categoriaSeleccionada ?? widget.categoriaInicial}-$searchText",
        ),
        categoriaInicial:
            categoriaSeleccionada ?? widget.categoriaInicial,
        search: searchText,
      ),

      const CestaPage(),
      const FavoritosPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              onSearch: (value) {
                setState(() {
                  searchText = value;
                  index = 1;
                });
              },

              // 🔥 AHORA ABRE COMO PANTALLA NUEVA
              onProfileTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PerfilPage(),
                  ),
                );
              },
            ),

            Expanded(child: pages[index]),
          ],
        ),
      ),

      /// 🔻 NAVBAR (SIN PERFIL)
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIcon(Icons.home, 0),
            _navIcon(Icons.local_offer, 1),
            _navIcon(Icons.shopping_cart, 2),
            _navIcon(Icons.favorite, 3),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int i) {
    final active = index == i;

    return GestureDetector(
      onTap: () {
        setState(() {
          index = i;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
      ),
    );
  }
}