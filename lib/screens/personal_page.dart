import 'package:flutter/material.dart';
import '../models/persona.dart';

class PersonalPage extends StatefulWidget {
  final Persona persona;

  PersonalPage({required this.persona});

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  //Clave para poder validar el formulario al darle a guardar
  final GlobalKey<FormState> _claveFormulario = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _fechaNacimientoController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  //Override para añadir los controladores del formulario
  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.persona.nombre);
    _apellidoController = TextEditingController(text: widget.persona.apellido);
    _fechaNacimientoController = TextEditingController(
      text:
          widget.persona.fechaNacimiento?.toLocal().toString().split(' ')[0] ??
              '',
    );
    _emailController = TextEditingController(text: widget.persona.email);
    _passwordController = TextEditingController(text: widget.persona.password);
  }

  //Seleccionador de fechas; en caso de usar en más widgets, mover a utilidades.dart
  Future<void> _seleccionarFecha(BuildContext context) async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (fechaSeleccionada != null && fechaSeleccionada != DateTime.now()) {
      _fechaNacimientoController.text =
          fechaSeleccionada.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.persona.apellido),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _claveFormulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Tu nombre debe tener al menos 3 caracteres.';
                  }
                  if (value.length > 15) {
                    return 'Tu nombre no puede tener más de 15 caracteres.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Tu apellido debe tener al menos 3 caracteres.';
                  }
                  if (value.length > 15) {
                    return 'Tu apellido no puede tener más de 15 caracteres.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration:
                    const InputDecoration(labelText: "Fecha de Nacimiento"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debes seleccionar una fecha de nacimiento.';
                  }
                  return null;
                },
                onTap: () => _seleccionarFecha(context),
                readOnly: true,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null ||
                      value.length > 50 ||
                      !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                    return 'Ingresa un email válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return 'La contraseña debe tener al menos 5 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //Validación de los campos del formulario
                  if (!_claveFormulario.currentState!.validate()) return;

                  //Guardar y enviar objeto persona modificado a HomePage
                  Persona personaModificada = Persona(
                      uuid: widget.persona.uuid,
                      nombre: _nombreController.text,
                      apellido: _apellidoController.text,
                      fechaNacimiento:
                          DateTime.parse(_fechaNacimientoController.text),
                      email: _emailController.text,
                      password: _passwordController.text,
                      conversaciones: widget.persona.conversaciones);

                  Navigator.pop(context, personaModificada);
                },
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
