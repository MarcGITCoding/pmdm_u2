import 'package:flutter/material.dart';
import '../utils/utilidades.dart';
import '../screens/personal_page.dart';
import '../screens/widget_page.dart';
import '../models/persona.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Creación de la persona base
  Persona _persona = Persona(
    uuid: Utilidades.generarUUID(),
    nombre: "Marc",
    apellido: "Sureda",
  );

  void actualizarPersona(Persona persona) {
    setState(() {
      _persona = persona;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SPPMMD"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bienvenido a SPPMMD",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50.0,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Esta es una aplicación donde podrás intercambiar mensajes con otras personas.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () async {
                      //Navigator.push y esperar a que se complete, para guardar en el widget actual
                      final personaModificada = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalPage(
                            persona: _persona,
                          ),
                        ),
                      );

                      //verificación de que se ha guardado
                      if (personaModificada == null) return;

                      actualizarPersona(personaModificada);

                      // Mostrar el apellido de la persona modificada
                      if (personaModificada != null &&
                          personaModificada is Persona) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(personaModificada.toString()),
                            duration: const Duration(seconds: 10),
                          ),
                        );
                      }
                    },
                    child: const Text("Editar perfil"),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WidgetPage(
                            persona: _persona,
                          ),
                        ),
                      );
                    },
                    child: const Text("Ver mensajes"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
