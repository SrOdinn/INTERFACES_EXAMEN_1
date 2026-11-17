import 'package:flutter/material.dart';
import 'ejercicio19.dart';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Quita la etiqueta DEBUG
      debugShowCheckedModeBanner: false,

      // Nombre de la aplicación
      title: 'Ejercicio 19 - Flutter',

      // Tema general de la aplicación
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),

      // Primera pantalla que se abre
      home: const Ejercicio19(),
    );
  }
}
