import 'producto.dart';
import 'usuario.dart';

class Cesta {
  final Producto producto;
  final Usuario usuario;

  Cesta({
    required this.producto,
    required this.usuario,
  });

  /// CONVERSIÓN DESDE JSON
  factory Cesta.fromJson(Map<String, dynamic> json) {
    return Cesta(
      producto: Producto.fromJson(json['producto']),
      usuario: Usuario.fromJson(json['usuario']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "producto": {
        "idPK": producto.id,
      },
      "usuario": {
        "idPK": usuario.idPK,
      }
    };
  }
}