import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';
import '../models/review.dart';

class ProductoDetallePage extends StatefulWidget {
  final Producto producto;

  const ProductoDetallePage({super.key, required this.producto});

  @override
  State<ProductoDetallePage> createState() =>
      _ProductoDetallePageState();
}

class _ProductoDetallePageState
    extends State<ProductoDetallePage> {
  List<Review> reviews = [];
  int indiceReview = 0;
  double ratingPromedio = 0;

  @override
  void initState() {
    super.initState();
    cargarReviews();
  }

  Future<void> cargarReviews() async {
    try {
      final reviewsConvertidos =
          await ApiService.obtenerReviews(widget.producto.id);

      final promedio = reviewsConvertidos.isEmpty
          ? 0.0
          : reviewsConvertidos
                  .map((r) => r.rating)
                  .reduce((a, b) => a + b) /
              reviewsConvertidos.length;

      setState(() {
        reviews = reviewsConvertidos;
        ratingPromedio = promedio;
      });
    } catch (e) {
      print("ERROR REVIEWS: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 4), cambiarReview);
  }

  void cambiarReview() {
    if (reviews.isEmpty) return;

    setState(() {
      indiceReview = (indiceReview + 1) % reviews.length;
    });

    Future.delayed(const Duration(seconds: 4), cambiarReview);
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🖼️ IMAGEN
              Stack(
                children: [
                  Image.network(
                    "http://192.168.0.6:8080/uploads/${producto.imagen}",
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
                        onPressed: () =>
                            Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      producto.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      producto.descripcion,
                      style: const TextStyle(
                          color: Colors.white70),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "\$${producto.precio} MXN",
                      style: const TextStyle(
                        color: Color(0xFF6F84A7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// ⭐ RATING
                    const Text(
                      "Rating & reviews",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Text(
                          ratingPromedio
                              .toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("/5",
                            style: TextStyle(
                                color: Colors.white54)),

                        const SizedBox(width: 10),

                        Row(
                          children:
                              List.generate(5, (index) {
                            return Icon(
                              index <
                                      ratingPromedio.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.blue,
                              size: 18,
                            );
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// 💬 REVIEW
                    if (reviews.isNotEmpty)
                      Container(
                        padding:
                            const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "@${reviews[indiceReview].usuario}",
                              style: const TextStyle(
                                  color: Colors.white70),
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children:
                                  List.generate(5, (i) {
                                return Icon(
                                  i <
                                          reviews[
                                                  indiceReview]
                                              .rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.blue,
                                  size: 16,
                                );
                              }),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              reviews[indiceReview]
                                  .comentario,
                              style: const TextStyle(
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}