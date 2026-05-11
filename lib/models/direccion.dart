class Direccion {

  final int idPK;

  final String numero;
  final String calle;
  final String colonia;
  final String cp;
  final String ciudad;
  final String municipio;
  final String estado;
  final String pais;

  Direccion({
    required this.idPK,
    required this.numero,
    required this.calle,
    required this.colonia,
    required this.cp,
    required this.ciudad,
    required this.municipio,
    required this.estado,
    required this.pais,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      idPK: json['idPK'] ?? 0,

      numero: json['numero'] ?? '',
      calle: json['calle'] ?? '',
      colonia: json['colonia'] ?? '',
      cp: json['cp'] ?? '',
      ciudad: json['ciudad'] ?? '',
      municipio: json['municipio'] ?? '',
      estado: json['estado'] ?? '',
      pais: json['pais'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idPK": idPK,
      "numero": numero,
      "calle": calle,
      "colonia": colonia,
      "cp": cp,
      "ciudad": ciudad,
      "municipio": municipio,
      "estado": estado,
      "pais": pais,
    };
  }
}