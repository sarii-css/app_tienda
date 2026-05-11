import 'direccion.dart';

class Cliente {

  final int idPk;
  final String nombre;
  final String telefono;
  final String genero;

  // 🔥 FECHA COMO STRING
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

      idPk: json['idPk'] ?? 0,

      nombre: json['nombre'] ?? '',

      telefono: json['telefono'] ?? '',

      genero: json['genero'] ?? '',

      // 🔥 EVITA ERROR SI VIENE NULL
      fechaNacimiento:
          json['fechaNacimiento']?.toString() ?? '',

      // 🔥 DIRECCION
      direccion: json['direccion'] != null
          ? Direccion.fromJson(json['direccion'])
          : Direccion(
              idPK: 0,
              numero: '',
              calle: '',
              colonia: '',
              cp: '',
              ciudad: '',
              municipio: '',
              estado: '',
              pais: '',
            ),

      usuarioFK: json['usuarioFK'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {

      "idPk": idPk,

      "nombre": nombre,

      "telefono": telefono,

      "genero": genero,

      "fechaNacimiento": fechaNacimiento,

      "direccion": direccion.toJson(),

      "usuarioFK": usuarioFK,
    };
  }
}