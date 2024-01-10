import 'package:pmdm_u2_suredamunarmarc/models/mensaje.dart';
import 'package:pmdm_u2_suredamunarmarc/models/persona.dart';

class Conversacion {
  Persona interlocutor;
  List<Mensaje> mensajes;

  Conversacion({
    required this.interlocutor,
    this.mensajes = const [],
  });

  void agregarMensaje(Mensaje mensaje) {
    mensajes.add(mensaje);
  }

  @override
  String toString() {
    //Para evitar la referencia circular, he puesto solo el número de mensajes
    return 'Conversacion{interlocutor: $interlocutor, mensajes: ${mensajes.length}}';
  }
}
