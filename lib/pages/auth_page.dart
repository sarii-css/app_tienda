import 'package:flutter/material.dart';
import 'registro_page.dart';

class AuthPage extends StatelessWidget {
  final VoidCallback onContinue;

  const AuthPage({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Benjie’s",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistroPage(), 
                  ),
                );
              },
              child: const Text("Sign in"),
            ),

            const SizedBox(height: 10),

            /// 🔑 LOGIN
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Placeholder(), 
                  ),
                );
              },
              child: const Text("Log in"),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: onContinue,
              child: const Text("Continuar sin cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}