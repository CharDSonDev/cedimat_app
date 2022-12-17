import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Model/cita.dart';
import '../../Model/especialidad.dart';
import '../../Model/medico.dart';
import '../../Model/paciente.dart';
import '../../Networking/cita.dart';
import '../../Networking/especialidades.dart';
import '../../Networking/medico.dart';
import '../../Networking/paciente.dart';

class CitaDetailsScreen extends StatefulWidget {
  final int citaId;

  const CitaDetailsScreen(
      {Key? key,
      required this.citaId,
      required int medicoId,
      required int pacienteId})
      : super(key: key);

  @override
  _CitaDetailsScreenState createState() => _CitaDetailsScreenState();
}

class _CitaDetailsScreenState extends State<CitaDetailsScreen> {
  Medico? _medico;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la cita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool? confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Eliminar cita'),
                    content: const Text(
                        '¿Estás seguro de que quieres eliminar esta cita?'),
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
                deleteCita(widget.citaId);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Cita>>(
        future: fetchCitas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Cita cita =
                snapshot.data!.firstWhere((cita) => cita.id == widget.citaId);
            DateTime fecha = DateTime.parse(cita.fecha);
            String fechaFormateada = DateFormat("dd/MM/yyyy").format(fecha);
            DateFormat timeFormat = DateFormat("HH:mm");
            DateTime hora = DateTime.parse(cita.hora);
            String horaFormateada = timeFormat.format(hora);

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<List<Especialidad>>(
                    future: fetchEspecialidades(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Especialidad especialidad = snapshot.data!.firstWhere(
                          (especialidad) =>
                              especialidad.id == _medico?.especialidadId,
                          orElse: () => Especialidad.empty,
                        );

                        if (especialidad != null) {
                          return Text.rich(
                            TextSpan(
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontSize: 20),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Especialidad: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: especialidad.nombre),
                              ],
                            ),
                          );
                        }
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<Medico>>(
                    future: fetchMedicos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Medico medico = snapshot.data!
                            .firstWhere((medico) => medico.id == cita.medicoId);
                        _medico = medico;
                        return RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontSize: 20),
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Médico: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: '${medico.nombre} ${medico.apellido}'),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            "Error al obtener el médico: ${snapshot.error}");
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<Paciente>>(
                    future: fetchPacientes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Paciente paciente = snapshot.data!.firstWhere(
                            (paciente) => paciente.id == cita.pacienteId);
                        return RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontSize: 20),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Paciente: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      '${paciente.nombre} ${paciente.apellido}'),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            "Error al obtener el paciente: ${snapshot.error}");
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 20),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Fecha: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: fechaFormateada),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 20),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Hora: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: horaFormateada),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error al obtener la cita: ${snapshot.error}");
          }
          return const LinearProgressIndicator();
        },
      ),
    );
  }
}
