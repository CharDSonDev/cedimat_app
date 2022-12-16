import 'dart:convert';

import 'package:cedimat_app/Model/paciente.dart';
import 'package:http/http.dart' as http;

Future<List<Paciente>> fetchPacientes() async {
  final response =
      await http.get(Uri.parse('https://localhost:7002/api/paciente'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Paciente.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pacientes');
  }
}

Future<List<Paciente>> fetchPaciente(int id) async {
  final response =
      await http.get(Uri.parse('https://localhost:7002/api/paciente$id'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Paciente.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pacientes');
  }
}


Future<Paciente> createAlbum(String nombre, String apellido, String cedula,
    String seguro, String telefono) async {
  final response = await http.post(
    Uri.parse('https://localhost:7002/api/paciente'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "nombre": nombre,
      "apellido": apellido,
      "cedula": cedula,
      "seguro": seguro,
      "telefono": telefono
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Paciente.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Paciente> updateAlbum(String nombre, String apellido, String cedula,
    String seguro, String telefono) async {
  final response = await http.put(
    Uri.parse('https://localhost:7002/api/paciente/4'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "nombre": nombre,
      "apellido": apellido,
      "cedula": cedula,
      "seguro": seguro,
      "telefono": telefono
    }),
  );

  return Paciente.fromJson(jsonDecode(response.body));
}

Future<Paciente> deleteAlbum(int id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://localhost:7002/api/paciente/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 204) {
    // If the server did return a 200 OK response,
    // then parse the JSON. After deleting,
    // you'll get an empty JSON `{}` response.
    // Don't return `null`, otherwise `snapshot.hasData`
    // will always return false on `FutureBuilder`.
    return Paciente.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a "200 OK response",
    // then throw an exception.
    throw Exception('Failed to delete album.');
  }
}
Future deletePaciente(int id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://localhost:7002/api/paciente/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}