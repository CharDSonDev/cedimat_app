class Cita {
  final int id;
  final String fecha;
  final String hora;
  final int pacienteId;
  final int medicoId;

  const Cita(
      {required this.id,
      required this.fecha,
      required this.hora,
      required this.pacienteId,
      required this.medicoId});

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
        id: json['id'],
        fecha: json['fecha'],
        hora: json['hora'],
        pacienteId: json['paciente_Id'],
        medicoId: json['medico_Id']);
  }
}
