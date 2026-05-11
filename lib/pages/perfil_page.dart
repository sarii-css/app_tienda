import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🔍 HEADER
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                    const SizedBox(width: 10),

                    /// BUSCADOR
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.white54),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                    const Icon(Icons.person_outline, color: Colors.white),
                  ],
                ),
              ),

              /// 👤 USER INFO
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Username",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text("id",
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),

                    const Spacer(),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                      ),
                      child: const Text("edit"),
                    )
                  ],
                ),
              ),

              /// 📋 MIS DATOS
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mis datos",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(height: 10),
                    Text("nombre:", style: TextStyle(color: Colors.white54)),
                    Text("telefono:", style: TextStyle(color: Colors.white54)),
                    Text("genero:", style: TextStyle(color: Colors.white54)),
                    Text("fecha de nacimiento:",
                        style: TextStyle(color: Colors.white54)),
                    Text("direccion:",
                        style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🚚 MIS PEDIDOS
              const Divider(color: Colors.white24),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Mis pedidos",
                      style: TextStyle(color: Colors.white)),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.receipt_long, color: Colors.white),
                  Icon(Icons.card_giftcard, color: Colors.white),
                  Icon(Icons.local_shipping, color: Colors.white),
                  Icon(Icons.playlist_add, color: Colors.white),
                ],
              ),

              const Divider(color: Colors.white24),

              /// ⚙️ OPCIONES
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.history, color: Colors.white),
                    Icon(Icons.support_agent, color: Colors.white),
                    Icon(Icons.settings, color: Colors.white),
                  ],
                ),
              ),

              const Divider(color: Colors.white24),

              /// 🛍️ RECOMENDADOS
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("También podría gustarte",
                    style: TextStyle(color: Colors.white)),
              ),

              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image, color: Colors.white54),
                          SizedBox(height: 10),
                          Text("Producto",
                              style: TextStyle(color: Colors.white54)),
                          SizedBox(height: 5),
                          Text("\$0.00",
                              style: TextStyle(color: Colors.lightBlue)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// 🔻 NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.label), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
        ],
      ),
    );
  }
}