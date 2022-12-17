import 'dart:convert';
import 'package:cedimat_app/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../Networking/cita.dart';

class CreateCita extends StatefulWidget {
  final int pacienteId;

  const CreateCita({Key? key, required this.pacienteId}) : super(key: key);
  @override
  State<CreateCita> createState() => _CreateCitaState();
}

class _CreateCitaState extends State<CreateCita> {
  TextEditingController fecha = TextEditingController();
  TextEditingController hora = TextEditingController();
  dynamic medicoId;
  List medicos = [];
  dynamic especialidadId;
  List especialidades = [];

  @override
  void initState() {
    super.initState();
    medicosItems();
    especialidadesItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          DropdownButtonFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'Especialidad'),
            items: especialidades.map((item) {
              return DropdownMenuItem(
                value: item['id'].toString(),
                child: Text(
                  '${item['nombre'] ?? ""}',
                ),
              );
            }).toList(),
            onChanged: (newVal) {
              if (especialidades
                  .any((item) => item['id'].toString() == newVal)) {
                setState(() {
                  especialidadId = newVal;
                  medicoId = null;
                });
                medicosItems();
              } else {
                setState(() {
                  especialidadId = null;
                });
              }
            },
            value: especialidadId,
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'Medico'),
            items: medicos.map((item) {
              return DropdownMenuItem(
                value: item['id'].toString(),
                child: Text(
                  '${item['nombre'] ?? ""} ${item['apellido'] ?? ""}',
                ),
              );
            }).toList(),
            onChanged: (newVal) {
              if (medicos.any((item) => item['id'].toString() == newVal)) {
                setState(() {
                  medicoId = newVal;
                });
              } else {
                setState(() {
                  medicoId = null;
                });
              }
            },
            value: medicoId,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
              controller: fecha,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Fecha'),
              readOnly: true,
              onTap: () async {
                // Obtener la fecha actual
                DateTime hoy = DateTime.now();
                // Mostrar el selector de fechas con la fecha actual como fecha inicial
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: hoy,
                    firstDate: hoy, // La primera fecha disponible es hoy
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);

                  setState(() {
                    fecha.text = formattedDate;
                  });
                } else {}
              }),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: hora,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.timer),
                labelText: "Hora"),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );

              if (pickedTime != null) {
                DateTime now = DateTime.now();
                DateTime selectedTime = DateTime(now.year, now.month, now.day,
                    pickedTime.hour, pickedTime.minute);
                String formattedTime = DateFormat.jm().format(
                    selectedTime); // formatea la hora seleccionada como "hh:mm AM/PM"

                setState(() {
                  hora.text = formattedTime;
                });
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DateTime now = DateTime.now();
          DateTime selectedTime = DateTime(
              now.year,
              now.month,
              now.day,
              int.parse(hora.text.substring(0, 2)),
              int.parse(hora.text.substring(3, 5)));
          String formattedTime =
              DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(selectedTime);

          createCita(fecha.text, formattedTime, widget.pacienteId, medicoId);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Future medicosItems() async {
    if (especialidadId == null) {
      setState(() {
        medicos = [];
      });
    } else {
      http.Response response = await http.get(Uri.parse(
          "https://localhost:7002/api/medico/especialidad/$especialidadId"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          medicos = jsonData;
        });
      }
    }
  }

  Future especialidadesItems() async {
    http.Response response =
        await http.get(Uri.parse("https://localhost:7002/api/especialidad"));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        especialidades = jsonData;
      });
    }
  }
}
