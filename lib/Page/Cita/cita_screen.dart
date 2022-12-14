import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/cita.dart';
import '../../Model/medico.dart';
import '../../Model/paciente.dart';
import '../../Networking/cita.dart';
import '../../Networking/medico.dart';
import '../../Networking/paciente.dart';
import 'cita_create.dart';
import 'cita_details.dart';

class CitasScreen extends StatelessWidget {
  final int pacienteId;

  CitasScreen({Key? key, required this.pacienteId}) : super(key: key);

  Future<List<Cita>>? _citasFuture;

  @override
  Widget build(BuildContext context) {
    _citasFuture ??= fetchCitas();

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Paciente>>(
          future: fetchPacientes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Paciente paciente = snapshot.data!
                  .firstWhere((paciente) => paciente.id == pacienteId);
              return Text('${paciente.nombre} ${paciente.apellido}');
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const LinearProgressIndicator();
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool? confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Eliminar paciente'),
                    content: const Text(
                        '¿Estás seguro de que quieres eliminar este paciente?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: const Text('Sí'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  );
                },
              );

              if (confirm != null) {
                deletePaciente(pacienteId);
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Cita>>(
        future: _citasFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Cita> citas = snapshot.data!
                .where((cita) => cita.pacienteId == pacienteId)
                .toList();
            return ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                Cita cita = citas[index];
                DateTime fecha = DateTime.parse(cita.fecha);
                String fechaFormateada = DateFormat("dd/MM/yyyy").format(fecha);
                return ListTile(
                  title: Text(fechaFormateada),
                  subtitle: FutureBuilder<List<Medico>>(
                    future: fetchMedicos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Obtener el médico con el ID de la cita
                        Medico medico = snapshot.data!
                            .firstWhere((medico) => medico.id == cita.medicoId);
                        return Text('${medico.nombre} ${medico.apellido}');
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CitaDetailsScreen(
                          citaId: cita.id,
                          medicoId: cita.medicoId,
                          pacienteId: cita.pacienteId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => CreateCita(
                pacienteId: pacienteId,
              ),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.event),
      ),
    );
  }
}
