class Especialidad {
  final int? id;
  final String? nombre;
  static final Especialidad empty = Especialidad(id: -1, nombre: "N/A");

  const Especialidad({required this.id, required this.nombre});

  factory Especialidad.fromJson(Map<String, dynamic> json) {
    return Especialidad(id: json['id'], nombre: json['nombre']);
  }
}
