class Medico {
  final int? id;
  final String? nombre;
  final String? apellido;
  final int? especialidadId;
  final int? horarioId;

  const Medico(
      {required this.id,
      required this.nombre,
      required this.apellido,
      required this.especialidadId,
      required this.horarioId});

  factory Medico.fromJson(Map<String, dynamic> json) {
    return Medico(
        id: json['id'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        especialidadId: json['especialidad_Id'],
        horarioId: json['horario_Id']);
  }
}
