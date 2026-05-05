class Usuario {
  final int idPK;
  final String nombreusuario;
  final String contrasena;
  final String correo;
  final int grupoFK;

  Usuario({
    required this.idPK,
    required this.nombreusuario,
    required this.contrasena,
    required this.correo,
    required this.grupoFK,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idPK: json['idPK'],
      nombreusuario: json['nombreusuario'],
      contrasena: json['contrasena'],
      correo: json['correo'],
      grupoFK: json['grupoFK'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idPK": idPK,
      "nombreusuario": nombreusuario,
      "contrasena": contrasena,
      "correo": correo,
      "grupoFK": grupoFK,
    };
  }
}