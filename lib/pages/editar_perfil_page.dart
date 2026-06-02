import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../models/cliente.dart';
import '../models/direccion.dart';

import '../services/cliente_service.dart';
import '../services/usuario_service.dart';

class EditarPerfilPage extends StatefulWidget {

  final Usuario usuario;
  final Cliente cliente;

  const EditarPerfilPage({
    super.key,
    required this.usuario,
    required this.cliente,
  });

  @override
  State<EditarPerfilPage> createState() =>
      _EditarPerfilPageState();
}

class _EditarPerfilPageState
    extends State<EditarPerfilPage> {

  late TextEditingController nombreController;
  late TextEditingController telefonoController;
  late TextEditingController correoController;

  late TextEditingController calleController;
  late TextEditingController numeroController;
  late TextEditingController coloniaController;
  late TextEditingController cpController;
  late TextEditingController ciudadController;
  late TextEditingController municipioController;
  late TextEditingController estadoController;
  late TextEditingController paisController;

  String genero = "";

  bool guardando = false;

  @override
  void initState() {
    super.initState();

    nombreController =
        TextEditingController(
      text: widget.cliente.nombre,
    );

    telefonoController =
        TextEditingController(
      text: widget.cliente.telefono,
    );

    correoController =
        TextEditingController(
      text: widget.usuario.correo,
    );

    genero = widget.cliente.genero;

    calleController =
        TextEditingController(
      text: widget.cliente.direccion.calle,
    );

    numeroController =
        TextEditingController(
      text: widget.cliente.direccion.numero,
    );

    coloniaController =
        TextEditingController(
      text: widget.cliente.direccion.colonia,
    );

    cpController =
        TextEditingController(
      text: widget.cliente.direccion.cp,
    );

    ciudadController =
        TextEditingController(
      text: widget.cliente.direccion.ciudad,
    );

    municipioController =
        TextEditingController(
      text: widget.cliente.direccion.municipio,
    );

    estadoController =
        TextEditingController(
      text: widget.cliente.direccion.estado,
    );

    paisController =
        TextEditingController(
      text: widget.cliente.direccion.pais,
    );
  }

  Future<void> guardar() async {

    setState(() {
      guardando = true;
    });

    try {

      final direccion = Direccion(
        idPK: widget.cliente.direccion.idPK,
        numero: numeroController.text,
        calle: calleController.text,
        colonia: coloniaController.text,
        cp: cpController.text,
        ciudad: ciudadController.text,
        municipio: municipioController.text,
        estado: estadoController.text,
        pais: paisController.text,
      );

      final cliente = Cliente(
        idPk: widget.cliente.idPk,
        nombre: nombreController.text,
        telefono: telefonoController.text,
        genero: genero,
        fechaNacimiento:
            widget.cliente.fechaNacimiento,
        direccion: direccion,
        usuarioFK: widget.cliente.usuarioFK,
      );

      await ClienteService.actualizarCliente(
        cliente,
      );

      await UsuarioService.actualizarCorreo(
        widget.usuario.idPK,
        correoController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Perfil actualizado",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  Widget campo(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        style:
            const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF0D0D0D),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0D0D0D),
        title: const Text(
          "Editar perfil",
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          children: [

            campo(
              "Nombre",
              nombreController,
            ),

            campo(
              "Teléfono",
              telefonoController,
            ),

            campo(
              "Correo",
              correoController,
            ),

            DropdownButtonFormField<String>(
              value: genero.isEmpty
                  ? null
                  : genero,
              dropdownColor:
                  Colors.grey[900],
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                labelText: "Género",
              ),
              items: const [
                DropdownMenuItem(
                  value: "Masculino",
                  child:
                      Text("Masculino"),
                ),
                DropdownMenuItem(
                  value: "Femenino",
                  child:
                      Text("Femenino"),
                ),
              ],
              onChanged: (value) {
                genero = value ?? "";
              },
            ),

            const SizedBox(height: 15),

            campo(
              "Calle",
              calleController,
            ),

            campo(
              "Número",
              numeroController,
            ),

            campo(
              "Colonia",
              coloniaController,
            ),

            campo(
              "CP",
              cpController,
            ),

            campo(
              "Ciudad",
              ciudadController,
            ),

            campo(
              "Municipio",
              municipioController,
            ),

            campo(
              "Estado",
              estadoController,
            ),

            campo(
              "País",
              paisController,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                onPressed:
                    guardando
                        ? null
                        : guardar,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white,
                  foregroundColor:
                      Colors.black,
                ),

                child: guardando
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Guardar cambios",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

