import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final Function(String) onSearch;

  const CustomHeader({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.image, color: Colors.black),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              onChanged: onSearch, // 🔥 AQUÍ VIVE EL SEARCH
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(width: 10),

          const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          )
        ],
      ),
    );
  }
}