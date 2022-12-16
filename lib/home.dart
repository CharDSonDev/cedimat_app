import 'package:cedimat_app/Model/paciente.dart';
import 'package:cedimat_app/Networking/paciente.dart';
import 'package:flutter/material.dart';

import 'Page/Cita/cita_screen.dart';
import 'Page/Paciente/paciente_create.dart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Paciente>> pacientesFuture = fetchPacientes();
  @override
  void initState() {
    super.initState();
    fetchPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Paciente>>(
        future: pacientesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Paciente>? pacientes = snapshot.data;
            return ListView.builder(
                itemCount: pacientes?.length,
                itemBuilder: (context, index) {
                  Paciente paciente = pacientes![index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(paciente.nombre.toString()),
                    subtitle: Text(paciente.apellido.toString()),
                    onTap: () =>
                        _showCitasScreen(context, paciente.id!.toInt()),
                  );
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const CreatePaciente(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showCitasScreen(BuildContext context, int pacienteId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitasScreen(pacienteId: pacienteId),
      ),
    );
  }
}
