import 'cliente.dart';
import 'direccion.dart';

class Usuario {

  final int idPK;
  final String nombreusuario;
  final String contrasena;
  final String correo;
  final int grupoFK;

  // 🔥 RELACIÓN
  final Cliente cliente;

  Usuario({
    required this.idPK,
    required this.nombreusuario,
    required this.contrasena,
    required this.correo,
    required this.grupoFK,
    required this.cliente,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(

      idPK: json['idPK'] ?? 0,

      nombreusuario: json['nombreusuario'] ?? '',

      contrasena: json['contrasena'] ?? '',

      correo: json['correo'] ?? '',

      grupoFK: json['grupoFK'] ?? 0,

      // 🔥 CLIENTE
      cliente: json['cliente'] != null
          ? Cliente.fromJson(json['cliente'])
          : Cliente(
              idPk: 0,
              nombre: '',
              telefono: '',
              genero: '',
              fechaNacimiento: '',

              direccion: Direccion(
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

              usuarioFK: 0,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {

      "idPK": idPK,

      "nombreusuario": nombreusuario,

      "contrasena": contrasena,

      "correo": correo,

      "grupoFK": grupoFK,

      "cliente": cliente.toJson(),
    };
  }
}