class Direccion {
  final int idPk;
  final String numero;
  final String calle;
  final String colonia;
  final String cp;
  final String ciudad;
  final String municipio;
  final String estado;
  final String pais;
  final int idCliente;

  Direccion({
    required this.idPk,
    required this.numero,
    required this.calle,
    required this.colonia,
    required this.cp,
    required this.ciudad,
    required this.municipio,
    required this.estado,
    required this.pais,
    required this.idCliente,
  });

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
      idPk: json['idPk'] ?? json['idPK'] ?? 0,
      numero: json['numero'] ?? '',
      calle: json['calle'] ?? '',
      colonia: json['colonia'] ?? '',
      cp: json['cp'] ?? '',
      ciudad: json['ciudad'] ?? '',
      municipio: json['municipio'] ?? '',
      estado: json['estado'] ?? '',
      pais: json['pais'] ?? '',
      idCliente: json['idCliente'] ?? 0,
    );
  }

  factory Direccion.vacia() {
    return Direccion(
      idPk: 0,
      numero: '',
      calle: '',
      colonia: '',
      cp: '',
      ciudad: '',
      municipio: '',
      estado: '',
      pais: '',
      idCliente: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idPk": idPk,
      "numero": numero,
      "calle": calle,
      "colonia": colonia,
      "cp": cp,
      "ciudad": ciudad,
      "municipio": municipio,
      "estado": estado,
      "pais": pais,
      "idCliente": idCliente,
    };
  }
}