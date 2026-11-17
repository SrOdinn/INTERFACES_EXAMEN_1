import 'package:flutter/material.dart';
import 'modelos/usuario.dart';

class FormularioRegistro extends StatefulWidget {
  final Function(Usuario) onRegistro;

  const FormularioRegistro({super.key, required this.onRegistro});

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  final formulario = GlobalKey<FormState>();

  final nombre = TextEditingController();
  final apellidos = TextEditingController();
  final correo = TextEditingController();
  final telefono = TextEditingController();
  final clave = TextEditingController();
  final confirmarClave = TextEditingController();

  String ciclo = 'DAM';
  DateTime? fechaNacimiento;
  bool aceptaCondiciones = false;
  bool ocultarClave = true;

  @override
  void dispose() {
    nombre.dispose();
    apellidos.dispose();
    correo.dispose();
    telefono.dispose();
    clave.dispose();
    confirmarClave.dispose();
    super.dispose();
  }

  void registrar() {
    if (!formulario.currentState!.validate()) return;

    if (fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona tu fecha de nacimiento')),
      );
      return;
    }

    if (!aceptaCondiciones) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar las condiciones')),
      );
      return;
    }

    final usuario = Usuario(
      nombre: nombre.text.trim(),
      apellidos: apellidos.text.trim(),
      correo: correo.text.trim(),
      clave: clave.text,
      ciclo: ciclo,
    );

    widget.onRegistro(usuario);
  }

  Future<void> elegirFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() => fechaNacimiento = fecha);
    }
  }

  Widget campo(
    String etiqueta,
    TextEditingController controlador, {
    TextInputType teclado = TextInputType.text,
    String? Function(String?)? validar,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controlador,
        keyboardType: teclado,
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
        ),
        validator:
            validar ??
            (valor) => (valor == null || valor.trim().isEmpty)
                ? 'Este campo es obligatorio'
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formulario,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Crear cuenta',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          campo('Nombre', nombre),
          campo('Apellidos', apellidos),

          campo(
            'Correo electrónico',
            correo,
            teclado: TextInputType.emailAddress,
            validar: (valor) {
              if (valor == null ||
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(valor.trim())) {
                return 'Correo no válido';
              }
              return null;
            },
          ),

          campo(
            'Teléfono',
            telefono,
            teclado: TextInputType.phone,
            validar: (valor) {
              if (!RegExp(r'^[0-9]{9}$').hasMatch(valor ?? '')) {
                return 'Introduce 9 números';
              }
              return null;
            },
          ),

          OutlinedButton(
            onPressed: elegirFecha,
            child: Text(
              fechaNacimiento == null
                  ? 'Seleccionar fecha de nacimiento'
                  : 'Nacimiento: ${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}',
            ),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: ciclo,
            decoration: const InputDecoration(
              labelText: 'Ciclo formativo',
              border: OutlineInputBorder(),
            ),
            items: ['DAM', 'DAW', 'ASIR']
                .map(
                  (opcion) =>
                      DropdownMenuItem(value: opcion, child: Text(opcion)),
                )
                .toList(),
            onChanged: (valor) {
              setState(() => ciclo = valor!);
            },
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: clave,
            obscureText: ocultarClave,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  ocultarClave ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => ocultarClave = !ocultarClave);
                },
              ),
            ),
            validator: (valor) {
              if (valor == null || valor.length < 8) {
                return 'Mínimo 8 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: confirmarClave,
            obscureText: ocultarClave,
            decoration: const InputDecoration(
              labelText: 'Confirmar contraseña',
              border: OutlineInputBorder(),
            ),
            validator: (valor) {
              if (valor != clave.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
          ),

          CheckboxListTile(
            title: const Text('Acepto las condiciones'),
            value: aceptaCondiciones,
            onChanged: (valor) {
              setState(() => aceptaCondiciones = valor ?? false);
            },
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: registrar,
            child: const Text('Registrarse'),
          ),
        ],
      ),
    );
  }
}
