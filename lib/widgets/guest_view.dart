import 'package:flutter/material.dart';
import '../pages/auth_page.dart'; 

class GuestView extends StatelessWidget {
  final String mensaje;

  const GuestView({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                color: Colors.white54,
                size: 60,
              ),

              const SizedBox(height: 20),

              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuthPage(
                        onContinue: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
                child: const Text("Iniciar sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}