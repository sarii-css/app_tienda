class Review {
  final String usuario;
  final int rating;
  final String comentario;

  Review({
    required this.usuario,
    required this.rating,
    required this.comentario,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      usuario: json['usuario'],
      rating: json['rating'],
      comentario: json['comentario'],
    );
  }
}