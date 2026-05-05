import 'producto.dart';
import 'usuario.dart';

class Favorito {
  final Producto producto;
  final Usuario usuario;

  Favorito({
    required this.producto,
    required this.usuario,
  });

  factory Favorito.fromJson(Map<String, dynamic> json) {
    return Favorito(
      producto: Producto.fromJson(json['producto']),
      usuario: Usuario.fromJson(json['usuario']),
    );
  }
}