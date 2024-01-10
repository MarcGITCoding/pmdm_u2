import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import '../models/persona.dart';
import '../models/conversacion.dart';
import '../models/mensaje.dart';
import '../utils/utilidades.dart';

class WidgetPage extends StatefulWidget {
  final Persona persona;

  WidgetPage({required this.persona});

  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  void _generarConversacionDePrueba() {
    setState(() {
      //Uso del paquete faker para generar datos aleatorios.
      final faker = Faker();

      final nuevaPersona = Persona(
        uuid: Utilidades.generarUUID(),
        nombre: faker.person.firstName(),
        apellido: faker.person.lastName(),
        email: faker.internet.email(),
      );

      //Creación de una conversación de prueba
      Conversacion conversacion = Conversacion(
        interlocutor: nuevaPersona,
        mensajes: [
          Mensaje(
            cuerpo: '¡Hola! Esto es un mensaje de prueba.',
            remitente: nuevaPersona,
            fechaEnvio: DateTime.now(),
          ),
        ],
      );

      //Añadir a la lista de conversaciones de la persona
      widget.persona.conversaciones.add(conversacion);
    });
  }

  //Formateo para subtítulo del ListTile
  String _formatearSubtitulo(Mensaje mensaje, Persona persona,
      {int maxLength = 30}) {
    final esRemitente = mensaje.remitente.uuid == persona.uuid;
    final cuerpo = mensaje.cuerpo.length > maxLength
        ? '${mensaje.cuerpo.substring(0, maxLength).trim()}...'
        : mensaje.cuerpo;

    return '${esRemitente ? 'Tú: ' : ''}$cuerpo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversaciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _generarConversacionDePrueba,
              child: const Text('Generar Conversacion de Prueba'),
            ),
            const SizedBox(height: 20),
            // ListView para mostrar conversaciones
            Expanded(
              child: ListView.builder(
                itemCount: widget.persona.conversaciones.length,
                itemBuilder: (context, index) {
                  Conversacion conversacion =
                      widget.persona.conversaciones[index];

                  return ListTile(
                    title: Text(
                        '${conversacion.interlocutor.nombre} ${conversacion.interlocutor.apellido}'),
                    subtitle: Text(
                      conversacion.mensajes.isNotEmpty
                          ? _formatearSubtitulo(
                              conversacion.mensajes.last, widget.persona,
                              maxLength: 30)
                          : 'No hay mensajes',
                    ),
                    onTap: () async {
                      // Muestra una nueva pantalla con los mensajes de la conversación seleccionada
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MensajesPage(
                              conversacion: conversacion,
                              persona: widget.persona),
                        ),
                      );

                      //Actualizamos la pantalla por si hay nuevos mensajes (y así actualizar el subtítulo)
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MensajesPage extends StatefulWidget {
  final Conversacion conversacion;
  final Persona persona;

  MensajesPage({required this.conversacion, required this.persona});

  @override
  _MensajesPageState createState() => _MensajesPageState();
}

class _MensajesPageState extends State<MensajesPage> {
  final TextEditingController _mensajeController = TextEditingController();

  void _enviarMensaje() {
    String mensajeTexto = _mensajeController.text;
    if (mensajeTexto.isNotEmpty) {
      //Crea un nuevo mensaje y lo añade a la conversación
      Mensaje nuevoMensaje = Mensaje(
        cuerpo: mensajeTexto,
        remitente: widget.persona,
        fechaEnvio: DateTime.now(),
      );

      setState(() {
        widget.conversacion.agregarMensaje(nuevoMensaje);
        //Limpiar el cuadro de texto después de enviar el mensaje
        _mensajeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensajes con ${widget.conversacion.interlocutor.nombre}'),
      ),
      body: Column(
        children: [
          //ListView para mostrar mensajes
          Expanded(
            child: ListView.builder(
              itemCount: widget.conversacion.mensajes.length,
              itemBuilder: (context, index) {
                Mensaje mensaje = widget.conversacion.mensajes[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.persona.uuid == mensaje.remitente.uuid
                                ? 'Tú'
                                : mensaje.remitente.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            Utilidades.formatFecha(mensaje.fechaEnvio),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(mensaje.cuerpo),
                      const SizedBox(height: 8),
                      const Divider(color: Colors.grey),
                    ],
                  ),
                );
              },
            ),
          ),

          //Cuadro de texto para escribir mensajes y botón para enviar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mensajeController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                    ),
                    onSubmitted: (_) => _enviarMensaje(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
