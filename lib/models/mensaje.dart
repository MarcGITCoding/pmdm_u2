import '../models/persona.dart';

class Mensaje {
  String cuerpo;
  Persona remitente;
  DateTime fechaEnvio;

  Mensaje({
    required this.cuerpo,
    required this.remitente,
    required this.fechaEnvio,
  });

  @override
  String toString() {
    return 'Mensaje{cuerpo: $cuerpo, remitente: $remitente, fechaEnvio: $fechaEnvio}';
  }
}
