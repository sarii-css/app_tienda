class Producto {
  final int id;
  final String nombre;
  final double precio;
  final String descripcion;
  final String color;
  final String talla;
  final String imagen;
  final String categoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.color,
    required this.talla,
    required this.imagen,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['idPK'],
      nombre: json['nombre'],
      precio: json['precio'].toDouble(),
      descripcion: json['descripcion'],
      color: json['color'],
      talla: json['talla'],
      imagen: json['imagen'],
      categoria: json['categoria']?['tipo'] ?? '',  
    );
  }
}