import '../models/conversacion.dart';

class Persona {
  String uuid;
  String nombre;
  String apellido;
  DateTime? fechaNacimiento;
  String email;
  String password;
  List<Conversacion> conversaciones;

  Persona({
    required this.uuid,
    required this.nombre,
    required this.apellido,
    this.fechaNacimiento,
    this.email = '',
    this.password = '',
    List<Conversacion>? conversaciones,
  }) : conversaciones = conversaciones ?? [];

  @override
  String toString() {
    //Para evitar la referencia circular, he puesto solo el número de conversaciones
    return 'Persona{uuid: $uuid, nombre: $nombre, apellido: $apellido, fechaNacimiento: $fechaNacimiento, email: $email, password: $password, conversaciones: ${conversaciones.length}}';
  }
}
