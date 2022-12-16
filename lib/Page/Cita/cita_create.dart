import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
              setState(() {
                especialidadId = newVal;
              });
              medicosItems();
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
              setState(() {
                medicoId = newVal;
              });
            },
            value: medicoId,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: fecha,
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Fecha',
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: hora,
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Hora',
                border: OutlineInputBorder()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createCita(fecha.text, hora.text, widget.pacienteId, medicoId);
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
