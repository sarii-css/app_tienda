import 'direccion.dart';

class Cliente {

  final int idPk;
  final String nombre;
  final String telefono;
  final String genero;
  final String fechaNacimiento;
  final Direccion direccion;
  final int usuarioFK;

  Cliente({
    required this.idPk,
    required this.nombre,
    required this.telefono,
    required this.genero,
    required this.fechaNacimiento,
    required this.direccion,
    required this.usuarioFK,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idPk: json['idPk'] ?? json['idPK'] ?? 0,
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
      genero: json['genero'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] ?? '',
      direccion: json['direccion'] != null
          ? Direccion.fromJson(json['direccion'])
          : Direccion.vacia(), 
      usuarioFK: json['usuarioFK'] ?? 0,
    );
  }

  factory Cliente.vacio() {
  return Cliente(
    idPk: 0,
    nombre: '',
    telefono: '',
    genero: '',
    fechaNacimiento: '',
    direccion: Direccion.vacia(),
    usuarioFK: 0,
  );
}

  Map<String, dynamic> toJson() {
    return {
      "idPK": idPk,
      "nombre": nombre,
      "telefono": telefono,
      "genero": genero,
      "fechaNacimiento": fechaNacimiento,
      "direccion": direccion.toJson(),
      "usuarioFK": usuarioFK,
    };
  }
}