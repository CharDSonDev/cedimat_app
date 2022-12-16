class Paciente {
  final int? id;
  final String? nombre;
  final String? apellido;
  final String? cedula;
  final String? seguro;
  final String? telefono;

  const Paciente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.seguro,
    required this.telefono,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      cedula: json['cedula'],
      seguro: json['seguro'],
      telefono: json['telefono'],
    );
  }
}