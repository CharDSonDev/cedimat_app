class Especialidad {
  final int? id;
  final String? nombre;

  const Especialidad(
      {required this.id,
      required this.nombre});

  factory Especialidad.fromJson(Map<String, dynamic> json) {
    return Especialidad(
        id: json['id'],
        nombre: json['nombre']);
  }
}
