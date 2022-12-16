import 'dart:convert';
import 'package:cedimat_app/Model/especialidad.dart';
import 'package:http/http.dart' as http;

Future<List<Especialidad>> fetchEspecialidades() async {
  final response =
      await http.get(Uri.parse('https://localhost:7002/api/especialidad'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Especialidad.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pacientes');
  }
}
