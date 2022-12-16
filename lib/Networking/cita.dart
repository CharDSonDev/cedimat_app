import 'dart:convert';
import 'package:cedimat_app/Model/cita.dart';
import 'package:http/http.dart' as http;

Future<List<Cita>> fetchCitas() async {
  final response = await http.get(Uri.parse('https://localhost:7002/api/cita'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Cita.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load pacientes');
  }
}

Future<List<Cita>> fetchCita(int id) async {
  final response =
      await http.get(Uri.parse('https://localhost:7002/api/cita/$id'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Cita.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load pacientes');
  }
}

Future<Cita> createCita(
    String fecha, String hora, int pacienteId, String medicoId) async {
  final response = await http.post(
    Uri.parse('https://localhost:7002/api/cita'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "fecha": fecha,
      "hora": hora,
      "paciente_Id": pacienteId,
      "medico_Id": medicoId
    }),
  );

  if (response.statusCode == 201) {
    return Cita.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}
