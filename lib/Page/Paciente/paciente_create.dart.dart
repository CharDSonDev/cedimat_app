import 'package:cedimat_app/Networking/paciente.dart';
import 'package:flutter/material.dart';

class CreatePaciente extends StatefulWidget {
  const CreatePaciente({super.key});

  @override
  State<CreatePaciente> createState() => _CreatePacienteState();
}

class _CreatePacienteState extends State<CreatePaciente> {
  TextEditingController nombre = TextEditingController();
  TextEditingController apellido = TextEditingController();
  TextEditingController cedula = TextEditingController();
  TextEditingController seguro = TextEditingController();
  TextEditingController telefono = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            controller: nombre,
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Nombre',
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: apellido,
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Apellido',
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: cedula,
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Cedula',
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: seguro,
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Seguro',
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: telefono,
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Telefono',
                border: OutlineInputBorder()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createAlbum(nombre.text, apellido.text, cedula.text, seguro.text,
              telefono.text);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
