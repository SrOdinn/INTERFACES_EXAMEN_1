// ============================================================================
// EJERCICIO 19 - VERSIÓN ESTUDIO Y CONSULTA PARA EL EXAMEN
// ============================================================================
//
// ESTE ARCHIVO ES UNA COPIA COMENTADA DEL EJERCICIO 19.
//
// OBJETIVO:
// - Entender qué hace cada parte del programa.
// - Localizar rápidamente funcionalidades.
// - Saber dónde escribir modificaciones.
// - Tener ejemplos de código reutilizables.
// - Mantener el programa original ejecutable.
//S
// IMPORTANTE:
// Los ejemplos de modificaciones están COMENTADOS.
// No se ejecutan hasta que los copies y adaptes.
//
// ÍNDICE PARA CTRL + F:
//
// BLOQUE 01 - IMPORTACIONES
// BLOQUE 02 - REGISTRO Y NAVEGACIÓN
// BLOQUE 03 - STATEFULWIDGET LOGIN
// BLOQUE 04 - VARIABLES Y CONTROLADORES
// BLOQUE 05 - VALIDACIÓN Y ENTRAR
// BLOQUE 06 - INTERFAZ DEL LOGIN
// BLOQUE 07 - VALIDADORES
// BLOQUE 08 - CONTRASEÑA Y ERRORES
// BLOQUE 09 - MODELO FOTO Y JSON
// BLOQUE 10 - STATEFULWIDGET PERFIL
// BLOQUE 11 - ESTADO DEL PERFIL
// BLOQUE 12 - API HTTP
// BLOQUE 13 - LISTAS Y TARJETAS
// BLOQUE 14 - FAVORITOS
// BLOQUE 15 - FILTROS Y BUSCADOR
// BLOQUE 16 - NAVEGACIÓN INFERIOR
// BLOQUE 17 - RECETAS DE FORMULARIOS
// BLOQUE 18 - RECETAS DE LISTAS
// BLOQUE 19 - RECETAS DE NAVEGACIÓN
// BLOQUE 20 - RECETAS DE DISEÑO
// BLOQUE 21 - RECETAS DE ESTADO
// BLOQUE 22 - RECETAS DE DART
// BLOQUE 23 - RESUMEN DE SINTAXIS
//
// ============================================================================

// ============================================================================
// BLOQUE 01 - IMPORTACIONES
// ============================================================================
//
// import permite utilizar código de otras bibliotecas.
//
// SI PIDEN:
// - Widgets de Flutter: material.dart.
// - JSON: dart:convert.
// - Peticiones HTTP: paquete http.
// - Clases de otros archivos: import con su ruta.
//
// OJO:
// Este archivo depende de otros tres archivos de tu proyecto:
// usuario.dart, imagen_remota.dart y ejercicio11.dart.
//
// El código de esas dependencias NO está incluido aquí.

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'modelos/usuario.dart';
import 'widgets/imagen_remota.dart';
import 'ejercicio11.dart';

// ============================================================================
// BLOQUE 02 - REGISTRO Y NAVEGACIÓN
// ============================================================================
//
// ¿QUÉ HACE?
// Muestra el formulario de registro.
// Cuando termina el registro, abre el login.
//
// StatelessWidget:
// Se utiliza cuando el widget no administra estado mutable propio.
//
// extends:
// Significa que la clase hereda de otra.
//
// @override:
// Indica que sobrescribimos un método de la clase padre.
//
// build:
// Devuelve la interfaz que se mostrará.
//
// Scaffold:
// Estructura de pantalla con appBar, body, etc.
//
// =>:
// Forma abreviada de devolver una expresión.
//
// SI PIDEN CREAR UNA PANTALLA SIN ESTADO:
// class Pantalla extends StatelessWidget {
//   const Pantalla({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Título')),
//       body: const Center(child: Text('Contenido')),
//     );
//   }
// }
//
// SI PIDEN ABRIR OTRA PANTALLA:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => const OtraPantalla(),
//   ),
// );
//
// SI PIDEN SUSTITUIR LA PANTALLA ACTUAL:
// Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (_) => const OtraPantalla(),
//   ),
// );
//
// DIFERENCIA:
// push = apila una pantalla nueva.
// pushReplacement = sustituye la pantalla actual.

class Ejercicio19 extends StatelessWidget {
  const Ejercicio19({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('19. Crear cuenta')),

    body: FormularioRegistro(
      // onRegistro recibe una función.
      //
      // usuario es el objeto recibido del formulario.
      //
      // Cuando se completa el registro,
      // sustituimos la pantalla por Login19.
      onRegistro: (usuario) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => Login19(usuario: usuario)),
        );
      },
    ),
  );
}

// ============================================================================
// BLOQUE 03 - STATEFULWIDGET LOGIN
// ============================================================================
//
// ¿CUÁNDO USAR STATEFULWIDGET?
// Cuando hay datos que cambian:
//
// - Contraseña visible/oculta.
// - Mensajes de error.
// - Contadores.
// - Checkboxes.
// - Favoritos.
// - Pestañas.
// - Listas modificables.
//
// StatefulWidget normalmente se divide en DOS clases:
//
// 1. Clase que recibe los datos.
// 2. Clase State que administra los cambios.
//
// final Usuario usuario:
// Usuario = tipo de dato.
// usuario = nombre del atributo.
// final = no se puede reasignar.
//
// required this.usuario:
// Obliga a pasar el usuario al crear Login19.
//
// super.key:
// Envía la clave al constructor de la clase padre.
//
// createState():
// Devuelve el State que controlará el widget.
//
// El guion bajo de _Login19State indica privacidad
// dentro de la biblioteca Dart.
//
// SI PIDEN PASAR UN DATO A UNA PANTALLA:
//
// class Pantalla extends StatefulWidget {
//   final String nombre;
//
//   const Pantalla({
//     super.key,
//     required this.nombre,
//   });
//
//   @override
//   State<Pantalla> createState() => _PantallaState();
// }
//
// class _PantallaState extends State<Pantalla> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Text(widget.nombre),
//     );
//   }
// }
//
// Para abrirla:
// Pantalla(nombre: 'Juan')
//
// Dentro de State:
// widget.nombre accede al dato recibido.

class Login19 extends StatefulWidget {
  final Usuario usuario;

  const Login19({super.key, required this.usuario});

  @override
  State<Login19> createState() => _Login19State();
}

// ============================================================================
// BLOQUE 04 - VARIABLES Y CONTROLADORES
// ============================================================================
//
// GlobalKey<FormState>:
// Permite acceder al estado de un formulario.
//
// TextEditingController:
// Permite recuperar el texto de un campo.
//
// controlador.text:
// Obtiene lo escrito por el usuario.
//
// bool:
// true o false.
//
// String?:
// String que también puede ser null.
//
// dispose():
// Libera controladores cuando se elimina el State.
//
// SI PIDEN AÑADIR UN CAMPO:
// 1. Crear un TextEditingController.
// 2. Crear su TextFormField.
// 3. Leer controlador.text.
// 4. Liberar el controlador en dispose().
//
// EJEMPLO:
//
// final telefono = TextEditingController();
//
// TextFormField(
//   controller: telefono,
//   decoration: const InputDecoration(
//     labelText: 'Teléfono',
//   ),
// ),
//
// Para leer:
// telefono.text
//
// En dispose():
// telefono.dispose();

class _Login19State extends State<Login19> {
  final formulario = GlobalKey<FormState>();

  final correo = TextEditingController();
  final clave = TextEditingController();

  bool ocultar = true;
  String? error;

  @override
  void dispose() {
    correo.dispose();
    clave.dispose();
    super.dispose();
  }

  // ==========================================================================
  // BLOQUE 05 - VALIDACIÓN Y ENTRAR
  // ==========================================================================
  //
  // ¿QUÉ HACE?
  // Comprueba el formulario.
  // Compara las credenciales.
  // Muestra un error si no coinciden.
  // Abre el perfil si son correctas.
  //
  // validate():
  // Ejecuta todos los validator del Form.
  //
  // !:
  // Delante de un booleano invierte su valor.
  //
  // return:
  // Termina el método.
  //
  // !=:
  // Diferente.
  //
  // ||:
  // O lógico.
  //
  // trim():
  // Elimina espacios al principio y al final.
  //
  // setState():
  // Actualiza la interfaz después de cambiar un dato.
  //
  // SI PIDEN MOSTRAR UN ERROR:
  //
  // String? error;
  //
  // setState(() {
  //   error = 'Ha ocurrido un error';
  // });
  //
  // Dentro de children:
  //
  // if (error != null)
  //   Text(
  //     error!,
  //     style: const TextStyle(color: Colors.red),
  //   ),
  //
  // SI PIDEN COMPROBAR DOS VALORES:
  //
  // if (valor1 == valor2) {
  //   // Son iguales.
  // } else {
  //   // Son diferentes.
  // }
  //
  // SI PIDEN COMPROBAR DOS CONDICIONES A LA VEZ:
  //
  // && = Y, deben cumplirse ambas.
  // || = O, basta con una.
  //
  // IMPORTANTE:
  // Esta comparación es local.
  // No representa un sistema de autenticación seguro.

  void entrar() {
    if (!formulario.currentState!.validate()) return;

    if (correo.text.trim() != widget.usuario.correo ||
        clave.text != widget.usuario.clave) {
      setState(() => error = 'El correo o la contraseña no coinciden');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => Perfil19(usuario: widget.usuario),
      ),
    );
  }

  // ==========================================================================
  // BLOQUE 06 - INTERFAZ DEL LOGIN
  // ==========================================================================
  //
  // Scaffold = pantalla.
  // AppBar = barra superior.
  // body = contenido.
  // Center = centra su hijo.
  // SingleChildScrollView = permite desplazamiento.
  // Padding = espacio interior.
  // ConstrainedBox = limita dimensiones.
  // Form = agrupa campos.
  // Column = elementos verticales.
  // Row = elementos horizontales.
  // SizedBox = espacio o tamaño fijo.
  //
  // child = UN widget.
  // children = LISTA de widgets.
  //
  // SI PIDEN DOS ELEMENTOS EN VERTICAL:
  //
  // Column(
  //   children: [
  //     const Text('Uno'),
  //     const Text('Dos'),
  //   ],
  // )
  //
  // SI PIDEN DOS ELEMENTOS EN HORIZONTAL:
  //
  // Row(
  //   children: [
  //     const Text('Uno'),
  //     const Text('Dos'),
  //   ],
  // )
  //
  // SI PIDEN CENTRAR UN WIDGET:
  //
  // const Center(
  //   child: Text('Centrado'),
  // )
  //
  // SI PIDEN EVITAR DESBORDAMIENTO CON EL TECLADO:
  //
  // SingleChildScrollView(
  //   child: Column(
  //     children: [...],
  //   ),
  // )

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('19. Iniciar sesión')),

    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),

          child: Form(
            key: formulario,

            child: Column(
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 90,
                  color: Colors.indigo,
                ),

                Text(
                  'Hola, ${widget.usuario.nombre}',
                  style: const TextStyle(fontSize: 26),
                ),

                const Text(
                  'Introduce el correo y la contraseña de tu registro.',
                ),

                const SizedBox(height: 24),

                // ============================================================
                // BLOQUE 07 - CAMPO DE CORREO Y VALIDADORES
                // ============================================================
                //
                // TextFormField:
                // Campo de texto que admite validator.
                //
                // controller:
                // Controlador asociado.
                //
                // keyboardType:
                // Tipo de teclado.
                //
                // decoration:
                // Configuración visual.
                //
                // validator:
                // Función que comprueba el valor.
                //
                // REGLA:
                // return null = campo correcto.
                // return 'Error' = campo incorrecto.
                //
                // SI PIDEN CAMPO OBLIGATORIO:
                //
                // validator: (v) {
                //   if (v == null || v.trim().isEmpty) {
                //     return 'Campo obligatorio';
                //   }
                //   return null;
                // },
                //
                // SI PIDEN MÍNIMO 8 CARACTERES:
                //
                // validator: (v) {
                //   if (v == null || v.isEmpty) {
                //     return 'Campo obligatorio';
                //   }
                //   if (v.length < 8) {
                //     return 'Mínimo 8 caracteres';
                //   }
                //   return null;
                // },
                //
                // SI PIDEN VALIDAR UNA EDAD:
                //
                // validator: (v) {
                //   final edad = int.tryParse(v ?? '');
                //
                //   if (edad == null) {
                //     return 'Introduce un número';
                //   }
                //
                //   if (edad < 18) {
                //     return 'Debes ser mayor de edad';
                //   }
                //
                //   return null;
                // },
                //
                // SI PIDEN VALIDAR UN CORREO:
                // Se puede utilizar RegExp como aquí.
                //
                // RegExp:
                // Expresión regular que reconoce un patrón.
                //
                // hasMatch():
                // Comprueba si el texto coincide.
                //
                // v?.trim():
                // Elimina espacios si v no es null.
                //
                // ?? '':
                // Si v es null, utiliza texto vacío.
                //
                // condicion ? valor1 : valor2:
                // Operador ternario.
                TextFormField(
                  controller: correo,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,

                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),

                  validator: (v) =>
                      RegExp(
                        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                      ).hasMatch(v?.trim() ?? '')
                      ? null
                      : 'Correo no válido',
                ),

                const SizedBox(height: 16),

                // ============================================================
                // BLOQUE 08 - CONTRASEÑA, VISIBILIDAD Y ERRORES
                // ============================================================
                //
                // obscureText:
                // true = oculta la contraseña.
                // false = muestra la contraseña.
                //
                // onFieldSubmitted:
                // Se ejecuta al enviar desde el teclado.
                //
                // suffixIcon:
                // Icono a la derecha del campo.
                //
                // IconButton:
                // Botón con icono.
                //
                // !ocultar:
                // Invierte el booleano.
                //
                // SI PIDEN MOSTRAR/OCULTAR CONTRASEÑA:
                //
                // bool ocultar = true;
                //
                // TextFormField(
                //   obscureText: ocultar,
                //   decoration: InputDecoration(
                //     suffixIcon: IconButton(
                //       onPressed: () {
                //         setState(() {
                //           ocultar = !ocultar;
                //         });
                //       },
                //       icon: Icon(
                //         ocultar
                //             ? Icons.visibility
                //             : Icons.visibility_off,
                //       ),
                //     ),
                //   ),
                // ),
                //
                // SI PIDEN COMPROBAR DOS CONTRASEÑAS:
                //
                // Necesitas dos controladores:
                //
                // final clave1 = TextEditingController();
                // final clave2 = TextEditingController();
                //
                // En el segundo TextFormField:
                //
                // validator: (v) {
                //   if (v != clave1.text) {
                //     return 'Las contraseñas no coinciden';
                //   }
                //   return null;
                // },
                //
                // También debes liberar ambos controladores
                // en dispose().
                TextFormField(
                  controller: clave,
                  obscureText: ocultar,
                  onFieldSubmitted: (_) => entrar(),

                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),

                    suffixIcon: IconButton(
                      onPressed: () => setState(() => ocultar = !ocultar),

                      icon: Icon(
                        ocultar ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),

                  validator: (v) =>
                      (v?.isEmpty ?? true) ? 'Introduce la contraseña' : null,
                ),

                // Mostramos el error solo si existe.
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 16),

                // onPressed: entrar
                // Pasa la función para ejecutarla al pulsar.
                //
                // onPressed: entrar()
                // NO sería correcto aquí porque la ejecutaría
                // inmediatamente al construir el widget.
                ElevatedButton(onPressed: entrar, child: const Text('Entrar')),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ============================================================================
// BLOQUE 09 - MODELO FOTO Y JSON
// ============================================================================
//
// ¿CUÁNDO UTILIZAR UNA CLASE MODELO?
// Cuando los datos tienen varios atributos.
//
// Ejemplos:
// - Usuario: nombre, correo, edad.
// - Producto: nombre, precio, imagen.
// - Foto: id, autor, URL.
//
// final String id, autor:
// Declara dos atributos String.
//
// Constructor:
// Foto(this.id, this.autor);
//
// get:
// Crea una propiedad calculada.
//
// factory Foto.fromJson:
// Convierte un mapa JSON en un objeto Foto.
//
// Map<String, dynamic>:
// Estructura de pares clave-valor.
//
// json['id']:
// Accede al valor de la clave id.
//
// as String:
// Indica el tipo esperado.
//
// SI PIDEN AÑADIR UN CAMPO AL MODELO:
//
// Por ejemplo, una descripción:
//
// 1. Añadir el atributo:
// final String descripcion;
//
// 2. Añadirlo al constructor:
// const Foto(this.id, this.autor, this.descripcion);
//
// 3. Añadirlo al fromJson:
// json['description'] as String
//
// IMPORTANTE:
// Solo funciona si la API realmente devuelve esa clave.
// No debes inventar campos JSON que no existan.

class Foto {
  final String id, autor;

  const Foto(this.id, this.autor);

  String get imagen => 'https://picsum.photos/id/$id/600/400';

  factory Foto.fromJson(Map<String, dynamic> json) =>
      Foto(json['id'] as String, json['author'] as String);
}

// ============================================================================
// BLOQUE 10 - STATEFULWIDGET PERFIL
// ============================================================================
//
// Esta pantalla recibe un Usuario y administra:
//
// - Fotografías.
// - Favoritos.
// - Pestañas.
// - Búsquedas.
// - Carga.
// - Errores.
//
// La estructura es la misma que en Login19.
//
// SI PIDEN OTRA PANTALLA CON ESTADO:
// Copiar la estructura de StatefulWidget + State,
// cambiar los nombres de las clases y adaptar el build.

class Perfil19 extends StatefulWidget {
  final Usuario usuario;

  const Perfil19({super.key, required this.usuario});

  @override
  State<Perfil19> createState() => _Perfil19State();
}

// ============================================================================
// BLOQUE 11 - VARIABLES DEL PERFIL
// ============================================================================
//
// int pestana:
// Guarda el índice seleccionado.
//
// List<Foto> fotos:
// Lista de fotografías.
//
// Set<String> favoritos:
// Conjunto de IDs sin duplicados.
//
// TextEditingController buscador:
// Lee el texto de búsqueda.
//
// String consulta:
// Guarda el filtro.
//
// bool cargando:
// Indica si estamos esperando datos.
//
// String? error:
// Mensaje de error opcional.
//
// initState():
// Se ejecuta al inicializar este State.
//
// dispose():
// Libera recursos.
//
// SI PIDEN CARGAR DATOS AL ABRIR:
// @override
// void initState() {
//   super.initState();
//   cargar();
// }
//
// SI PIDEN UNA LISTA VACÍA:
// List<String> elementos = [];
//
// SI PIDEN UN CONJUNTO SIN DUPLICADOS:
// Set<String> seleccionados = {};
//
// SI PIDEN UN CONTADOR:
// int contador = 0;
//
// Para cambiarlo:
// setState(() => contador++);

class _Perfil19State extends State<Perfil19> {
  int pestana = 0;
  List<Foto> fotos = [];
  final favoritos = <String>{};
  final buscador = TextEditingController();
  String consulta = '';
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  @override
  void dispose() {
    buscador.dispose();
    super.dispose();
  }

  // ==========================================================================
  // BLOQUE 12 - API HTTP
  // ==========================================================================
  //
  // ¿CUÁNDO UTILIZARLO?
  // Si piden obtener información de internet.
  //
  // Future<void>:
  // Operación asíncrona sin resultado útil.
  //
  // async:
  // Permite utilizar await.
  //
  // await:
  // Espera el resultado de una operación.
  //
  // http.get:
  // Realiza una petición GET.
  //
  // Uri.parse:
  // Convierte un String en URI.
  //
  // timeout:
  // Limita el tiempo de espera.
  //
  // statusCode:
  // Código de respuesta HTTP.
  //
  // 200:
  // Respuesta correcta.
  //
  // jsonDecode:
  // Convierte texto JSON en datos Dart.
  //
  // map:
  // Transforma cada elemento.
  //
  // toList:
  // Convierte el resultado en lista.
  //
  // try:
  // Código que puede fallar.
  //
  // catch:
  // Captura el error.
  //
  // finally:
  // Se ejecuta tanto si hay error como si no.
  //
  // mounted:
  // Comprueba si el State sigue activo.
  //
  // SI PIDEN CAMBIAR LA API:
  //
  // 1. Cambiar la URL en http.get.
  // 2. Comprobar si devuelve lista u objeto.
  // 3. Adaptar el modelo Foto.
  // 4. Adaptar fromJson a las claves reales.
  // 5. Adaptar los widgets que muestran los datos.
  //
  // OJO:
  // Cambiar solo la URL no basta si el JSON
  // tiene otra estructura.
  //
  // SI PIDEN BOTÓN DE RECARGAR:
  //
  // ElevatedButton(
  //   onPressed: cargar,
  //   child: const Text('Recargar'),
  // ),
  //
  // SI PIDEN INDICADOR DE CARGA:
  //
  // if (cargando)
  //   const CircularProgressIndicator(),
  //
  // SI PIDEN CONTROLAR ERRORES:
  //
  // try {
  //   // Código que puede fallar.
  // } catch (e) {
  //   print('Error: $e');
  // }
  //
  // SI PIDEN MOSTRAR DATOS SIN INTERNET:
  // Necesitas datos locales o datos guardados.
  // Este método original depende de la conexión.

  Future<void> cargar() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final respuesta = await http
          .get(Uri.parse('https://picsum.photos/v2/list?limit=24'))
          .timeout(const Duration(seconds: 15));

      if (respuesta.statusCode != 200) {
        throw Exception('HTTP ${respuesta.statusCode}');
      }

      final datos = jsonDecode(respuesta.body) as List;

      final resultado = datos
          .map((dato) => Foto.fromJson(dato as Map<String, dynamic>))
          .toList();

      if (mounted) {
        setState(() => fotos = resultado);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () =>
              error = 'No se pudieron cargar las fotos. Comprueba la conexión.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => cargando = false);
      }
    }
  }

  // ==========================================================================
  // BLOQUE 13 - LISTAS Y TARJETAS
  // ==========================================================================
  //
  // listado recibe una lista de Foto.
  //
  // Si está cargando, muestra un indicador.
  // Si hay error, muestra el mensaje.
  // Si está vacía, muestra un aviso.
  // Si tiene datos, muestra ListView.builder.
  //
  // ListView.builder:
  // Construye listas dinámicas.
  //
  // itemCount:
  // Número de elementos.
  //
  // itemBuilder:
  // Función que construye cada elemento.
  //
  // datos[i]:
  // Elemento de la posición i.
  //
  // Card:
  // Tarjeta visual.
  //
  // ListTile:
  // Fila con título, subtítulo e iconos.
  //
  // SI PIDEN MOSTRAR UNA LISTA DE TEXTOS:
  //
  // List<String> nombres = ['Ana', 'Luis', 'Marta'];
  //
  // ListView.builder(
  //   itemCount: nombres.length,
  //   itemBuilder: (context, i) {
  //     return ListTile(
  //       title: Text(nombres[i]),
  //     );
  //   },
  // )
  //
  // SI PIDEN UNA CUADRÍCULA:
  //
  // GridView.builder(
  //   gridDelegate:
  //       const SliverGridDelegateWithFixedCrossAxisCount(
  //     crossAxisCount: 2,
  //   ),
  //   itemCount: datos.length,
  //   itemBuilder: (context, i) {
  //     return Card(
  //       child: Text(datos[i].autor),
  //     );
  //   },
  // )
  //
  // SI PIDEN MOSTRAR MENSAJE CUANDO ESTÁ VACÍA:
  //
  // if (datos.isEmpty) {
  //   return const Center(
  //     child: Text('No hay resultados'),
  //   );
  // }

  Widget listado(List<Foto> datos) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.all(16), child: Text(error!)),
            ElevatedButton(onPressed: cargar, child: const Text('Reintentar')),
          ],
        ),
      );
    }

    if (datos.isEmpty) {
      return Center(
        child: Text(
          pestana == 2
              ? 'Todavía no tienes fotos favoritas. Pulsa un corazón en Feeds.'
              : 'No hay fotos para mostrar.',
        ),
      );
    }

    return ListView.builder(
      key: PageStorageKey('fotos$pestana'),
      itemCount: datos.length,
      padding: const EdgeInsets.all(12),

      itemBuilder: (context, i) {
        final foto = datos[i];

        return Card(
          clipBehavior: Clip.antiAlias,

          child: Column(
            children: [
              ImagenRemota(foto.imagen, ancho: double.infinity, alto: 220),

              ListTile(
                title: Text(foto.autor),
                subtitle: Text('Foto ${foto.id}'),

                trailing: IconButton(
                  tooltip: 'Favorita ${foto.id}',

                  icon: Icon(
                    favoritos.contains(foto.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),

                  // ==========================================================
                  // BLOQUE 14 - FAVORITOS
                  // ==========================================================
                  //
                  // favoritos es un Set<String>.
                  //
                  // add:
                  // Añade un elemento.
                  //
                  // remove:
                  // Elimina un elemento.
                  //
                  // contains:
                  // Comprueba si existe.
                  //
                  // length:
                  // Devuelve la cantidad.
                  //
                  // clear:
                  // Vacía el conjunto.
                  //
                  // SI PIDEN CONTAR FAVORITOS:
                  //
                  // Text('Favoritos: ${favoritos.length}'),
                  //
                  // SI PIDEN BORRAR TODOS LOS FAVORITOS:
                  //
                  // ElevatedButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       favoritos.clear();
                  //     });
                  //   },
                  //   child: const Text('Borrar favoritos'),
                  // ),
                  //
                  // SI PIDEN AÑADIR UN FAVORITO:
                  //
                  // setState(() {
                  //   favoritos.add(foto.id);
                  // });
                  //
                  // SI PIDEN QUITAR UN FAVORITO:
                  //
                  // setState(() {
                  //   favoritos.remove(foto.id);
                  // });
                  //
                  // SI PIDEN ALTERNAR FAVORITO:
                  //
                  // setState(() {
                  //   if (favoritos.contains(foto.id)) {
                  //     favoritos.remove(foto.id);
                  //   } else {
                  //     favoritos.add(foto.id);
                  //   }
                  // });
                  //
                  // SI PIDEN MOSTRAR SOLO FAVORITOS:
                  //
                  // final soloFavoritos = fotos.where(
                  //   (f) => favoritos.contains(f.id),
                  // ).toList();
                  onPressed: () => setState(() {
                    if (!favoritos.add(foto.id)) {
                      favoritos.remove(foto.id);
                    }
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // BLOQUE 15 - FILTROS Y BUSCADOR
  // ==========================================================================
  //
  // where:
  // Filtra una colección.
  //
  // contains:
  // Comprueba si un texto contiene otro.
  //
  // toLowerCase:
  // Convierte a minúsculas.
  //
  // toList:
  // Convierte el resultado en lista.
  //
  // SI PIDEN BUSCAR POR NOMBRE:
  //
  // final filtrados = fotos.where(
  //   (f) => f.autor.toLowerCase().contains(
  //     consulta.toLowerCase(),
  //   ),
  // ).toList();
  //
  // SI PIDEN BUSCAR POR ID:
  //
  // final filtrados = fotos.where(
  //   (f) => f.id == consulta,
  // ).toList();
  //
  // SI PIDEN FILTRAR POR DOS CONDICIONES:
  //
  // && = deben cumplirse ambas.
  // || = basta con una.
  //
  // SI PIDEN ORDENAR ALFABÉTICAMENTE:
  //
  // setState(() {
  //   fotos.sort(
  //     (a, b) => a.autor.compareTo(b.autor),
  //   );
  // });
  //
  // SI PIDEN ORDEN INVERSO:
  //
  // setState(() {
  //   fotos.sort(
  //     (a, b) => b.autor.compareTo(a.autor),
  //   );
  // });
  //
  // SI PIDEN BUSCAR EN TIEMPO REAL:
  //
  // En un TextField:
  //
  // onChanged: (valor) {
  //   setState(() {
  //     consulta = valor;
  //   });
  // },
  //
  // Así se actualiza mientras se escribe,
  // sin tener que pulsar Buscar.

  @override
  Widget build(BuildContext context) {
    final filtradas = fotos
        .where(
          (f) =>
              f.autor.toLowerCase().contains(consulta.toLowerCase()) ||
              f.id == consulta,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.usuario.nombre} ${widget.usuario.apellidos}'),

        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',

            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (_) => Login19(usuario: widget.usuario),
              ),
            ),

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),

            title: Text(widget.usuario.correo),

            subtitle: Text('${widget.usuario.ciclo} · Mi perfil personal'),
          ),

          Expanded(
            child: pestana == 0
                ? listado(fotos)
                : pestana == 2
                ? listado(fotos.where((f) => favoritos.contains(f.id)).toList())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),

                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: buscador,

                                onSubmitted: (_) => setState(
                                  () => consulta = buscador.text.trim(),
                                ),

                                decoration: const InputDecoration(
                                  labelText: 'Autor o ID',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            ElevatedButton(
                              onPressed: () => setState(
                                () => consulta = buscador.text.trim(),
                              ),

                              child: const Text('Buscar'),
                            ),
                          ],
                        ),
                      ),

                      Expanded(child: listado(filtradas)),
                    ],
                  ),
          ),
        ],
      ),

      // ======================================================================
      // BLOQUE 16 - NAVEGACIÓN INFERIOR
      // ======================================================================
      //
      // NavigationBar:
      // Barra inferior con distintas secciones.
      //
      // selectedIndex:
      // Índice de la sección activa.
      //
      // onDestinationSelected:
      // Se ejecuta al pulsar una pestaña.
      //
      // NavigationDestination:
      // Define una pestaña.
      //
      // SI PIDEN AÑADIR OTRA PESTAÑA:
      //
      // 1. Añadir otro NavigationDestination.
      // 2. Darle un índice nuevo.
      // 3. Añadir la condición que muestra su contenido.
      //
      // EJEMPLO DE NUEVO DESTINO:
      //
      // NavigationDestination(
      //   icon: Icon(Icons.settings),
      //   label: 'Ajustes',
      // ),
      //
      // IMPORTANTE:
      // Añadir el destino no basta.
      // También debes modificar el body para
      // mostrar la pantalla correspondiente.
      bottomNavigationBar: NavigationBar(
        selectedIndex: pestana,

        onDestinationSelected: (i) => setState(() => pestana = i),

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Feeds',
          ),

          NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),

          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
      ),
    );
  }
}

// ============================================================================
// BLOQUE 17 - RECETAS DE FORMULARIOS
// ============================================================================
//
// ESTOS EJEMPLOS SON PLANTILLAS.
// ESTÁN COMENTADOS PARA NO ALTERAR EL EJERCICIO ORIGINAL.
//
// ---------------------------------------------------------------------------
// SI PIDEN AÑADIR UN CAMPO DE EDAD
// ---------------------------------------------------------------------------
//
// DÓNDE:
// Dentro de la clase State del formulario.
//
// PASO 1: Declarar controlador:
//
// final edad = TextEditingController();
//
// PASO 2: Añadir dentro de children:
//
// TextFormField(
//   controller: edad,
//   keyboardType: TextInputType.number,
//   decoration: const InputDecoration(
//     labelText: 'Edad',
//     border: OutlineInputBorder(),
//   ),
//   validator: (v) {
//     final numero = int.tryParse(v ?? '');
//
//     if (numero == null) {
//       return 'Introduce una edad válida';
//     }
//
//     if (numero < 18) {
//       return 'Debes ser mayor de edad';
//     }
//
//     return null;
//   },
// ),
//
// PASO 3: En dispose():
//
// edad.dispose();
//
// ---------------------------------------------------------------------------
// SI PIDEN UN DESPLEGABLE
// ---------------------------------------------------------------------------
//
// DÓNDE:
// Dentro de children de un Form.
//
// En el State:
//
// String? cicloSeleccionado;
//
// En el Form:
//
// DropdownButtonFormField<String>(
//   initialValue: cicloSeleccionado,
//   decoration: const InputDecoration(
//     labelText: 'Ciclo',
//   ),
//   items: const [
//     DropdownMenuItem(
//       value: 'DAM',
//       child: Text('DAM'),
//     ),
//     DropdownMenuItem(
//       value: 'DAW',
//       child: Text('DAW'),
//     ),
//   ],
//   onChanged: (valor) {
//     setState(() {
//       cicloSeleccionado = valor;
//     });
//   },
//   validator: (valor) {
//     if (valor == null) {
//       return 'Selecciona un ciclo';
//     }
//     return null;
//   },
// ),
//
// NOTA:
// En versiones anteriores de Flutter puede utilizarse
// value: en lugar de initialValue:.
//
// ---------------------------------------------------------------------------
// SI PIDEN UNA CASILLA DE ACEPTAR CONDICIONES
// ---------------------------------------------------------------------------
//
// En el State:
//
// bool acepta = false;
//
// Dentro de children:
//
// CheckboxListTile(
//   title: const Text('Acepto las condiciones'),
//   value: acepta,
//   onChanged: (valor) {
//     setState(() {
//       acepta = valor ?? false;
//     });
//   },
// ),
//
// Antes de continuar:
//
// if (!acepta) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text('Debes aceptar las condiciones'),
//     ),
//   );
//   return;
// }
//
// ---------------------------------------------------------------------------
// SI PIDEN LIMPIAR UN FORMULARIO
// ---------------------------------------------------------------------------
//
// DÓNDE:
// En el onPressed de un botón.
//
// setState(() {
//   correo.clear();
//   clave.clear();
//   error = null;
// });
//
// formulario.currentState?.reset();
//
// OJO:
// reset() restablece el estado de los FormField.
// Si utilizas controladores, clear() borra su texto.
//
// ---------------------------------------------------------------------------
// SI PIDEN MOSTRAR UN MENSAJE TEMPORAL
// ---------------------------------------------------------------------------
//
// ScaffoldMessenger.of(context).showSnackBar(
//   const SnackBar(
//     content: Text('Operación completada'),
//   ),
// );
//
// ---------------------------------------------------------------------------
// SI PIDEN MOSTRAR UN DIÁLOGO
// ---------------------------------------------------------------------------
//
// showDialog<void>(
//   context: context,
//   builder: (context) => AlertDialog(
//     title: const Text('Aviso'),
//     content: const Text('Operación completada'),
//     actions: [
//       TextButton(
//         onPressed: () => Navigator.pop(context),
//         child: const Text('Aceptar'),
//       ),
//     ],
//   ),
// );
//
// ============================================================================
// BLOQUE 18 - RECETAS DE LISTAS
// ============================================================================
//
// ---------------------------------------------------------------------------
// SI PIDEN AÑADIR ELEMENTOS
// ---------------------------------------------------------------------------
//
// En el State:
//
// List<String> nombres = [];
//
// En un botón:
//
// setState(() {
//   nombres.add('Nuevo nombre');
// });
//
// ---------------------------------------------------------------------------
// SI PIDEN ELIMINAR POR ÍNDICE
// ---------------------------------------------------------------------------
//
// setState(() {
//   nombres.removeAt(0);
// });
//
// OJO: la lista debe tener un elemento en esa posición.
//
// ---------------------------------------------------------------------------
// SI PIDEN ELIMINAR POR CONDICIÓN
// ---------------------------------------------------------------------------
//
// setState(() {
//   fotos.removeWhere(
//     (f) => f.id == '10',
//   );
// });
//
// removeWhere elimina todos los elementos
// que cumplan la condición.
//
// ---------------------------------------------------------------------------
// SI PIDEN CONTAR ELEMENTOS
// ---------------------------------------------------------------------------
//
// Text('Total: ${fotos.length}'),
//
// ---------------------------------------------------------------------------
// SI PIDEN ORDENAR
// ---------------------------------------------------------------------------
//
// setState(() {
//   fotos.sort(
//     (a, b) => a.autor.compareTo(b.autor),
//   );
// });
//
// ---------------------------------------------------------------------------
// SI PIDEN MOSTRAR UNA CUADRÍCULA DE DOS COLUMNAS
// ---------------------------------------------------------------------------
//
// GridView.builder(
//   gridDelegate:
//       const SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 8,
//     mainAxisSpacing: 8,
//   ),
//   itemCount: fotos.length,
//   itemBuilder: (context, i) {
//     final foto = fotos[i];
//
//     return Card(
//       child: Column(
//         children: [
//           Text(foto.autor),
//           Text(foto.id),
//         ],
//       ),
//     );
//   },
// ),
//
// ============================================================================
// BLOQUE 19 - RECETAS DE NAVEGACIÓN
// ============================================================================
//
// ---------------------------------------------------------------------------
// SI PIDEN ABRIR UNA PANTALLA
// ---------------------------------------------------------------------------
//
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => const PantallaDestino(),
//   ),
// );
//
// PantallaDestino debe existir en el proyecto.
//
// ---------------------------------------------------------------------------
// SI PIDEN SUSTITUIR LA PANTALLA
// ---------------------------------------------------------------------------
//
// Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (_) => const PantallaDestino(),
//   ),
// );
//
// ---------------------------------------------------------------------------
// SI PIDEN VOLVER ATRÁS
// ---------------------------------------------------------------------------
//
// Navigator.pop(context);
//
// ---------------------------------------------------------------------------
// SI PIDEN PASAR UN STRING ENTRE PANTALLAS
// ---------------------------------------------------------------------------
//
// PANTALLA DESTINO:
//
// class PantallaDestino extends StatelessWidget {
//   final String nombre;
//
//   const PantallaDestino({
//     super.key,
//     required this.nombre,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(nombre),
//       ),
//     );
//   }
// }
//
// PARA ABRIRLA:
//
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => const PantallaDestino(
//       nombre: 'Juan',
//     ),
//   ),
// );
//
// ============================================================================
// BLOQUE 20 - RECETAS DE DISEÑO
// ============================================================================
//
// ---------------------------------------------------------------------------
// SI PIDEN CAMBIAR COLOR DE FONDO
// ---------------------------------------------------------------------------
//
// Scaffold(
//   backgroundColor: Colors.blue,
//   body: const Center(
//     child: Text('Hola'),
//   ),
// )
//
// ---------------------------------------------------------------------------
// SI PIDEN UN CONTENEDOR CON BORDE
// ---------------------------------------------------------------------------
//
// Container(
//   padding: const EdgeInsets.all(16),
//   decoration: BoxDecoration(
//     color: Colors.white,
//     border: Border.all(color: Colors.black),
//     borderRadius: BorderRadius.circular(12),
//   ),
//   child: const Text('Contenido'),
// )
//
// ---------------------------------------------------------------------------
// SI PIDEN UNA TARJETA
// ---------------------------------------------------------------------------
//
// Card(
//   elevation: 4,
//   child: Padding(
//     padding: const EdgeInsets.all(16),
//     child: Column(
//       children: [
//         const Text('Título'),
//         const Text('Descripción'),
//       ],
//     ),
//   ),
// )
//
// ---------------------------------------------------------------------------
// SI PIDEN DISTRIBUIR EL ESPACIO
// ---------------------------------------------------------------------------
//
// Row(
//   children: [
//     Expanded(
//       child: ElevatedButton(
//         onPressed: () {},
//         child: const Text('Uno'),
//       ),
//     ),
//     Expanded(
//       child: ElevatedButton(
//         onPressed: () {},
//         child: const Text('Dos'),
//       ),
//     ),
//   ],
// )
//
// ---------------------------------------------------------------------------
// SI PIDEN UNA IMAGEN DE INTERNET
// ---------------------------------------------------------------------------
//
// Image.network(
//   'https://ejemplo.com/imagen.jpg',
//   width: 200,
//   height: 150,
//   fit: BoxFit.cover,
// )
//
// La URL es un ejemplo.
// Debes sustituirla por una dirección válida.
//
// ============================================================================
// BLOQUE 21 - RECETAS DE ESTADO
// ============================================================================
//
// ---------------------------------------------------------------------------
// SI PIDEN UN CONTADOR
// ---------------------------------------------------------------------------
//
// Dentro de State:
//
// int contador = 0;
//
// Dentro de children:
//
// Text('$contador'),
//
// ElevatedButton(
//   onPressed: () {
//     setState(() {
//       contador++;
//     });
//   },
//   child: const Text('Sumar'),
// ),
//
// ---------------------------------------------------------------------------
// SI PIDEN RESTAR SIN BAJAR DE CERO
// ---------------------------------------------------------------------------
//
// ElevatedButton(
//   onPressed: () {
//     if (contador > 0) {
//       setState(() {
//         contador--;
//       });
//     }
//   },
//   child: const Text('Restar'),
// ),
//
// ---------------------------------------------------------------------------
// SI PIDEN REINICIAR
// ---------------------------------------------------------------------------
//
// ElevatedButton(
//   onPressed: () {
//     setState(() {
//       contador = 0;
//     });
//   },
//   child: const Text('Reiniciar'),
// ),
//
// ---------------------------------------------------------------------------
// SI PIDEN UN INTERRUPTOR
// ---------------------------------------------------------------------------
//
// En State:
//
// bool activado = false;
//
// En children:
//
// Switch(
//   value: activado,
//   onChanged: (valor) {
//     setState(() {
//       activado = valor;
//     });
//   },
// ),
//
// ---------------------------------------------------------------------------
// SI PIDEN CAMBIAR UN COLOR SEGÚN UNA CONDICIÓN
// ---------------------------------------------------------------------------
//
// Text(
//   '$contador',
//   style: TextStyle(
//     color: contador > 10 ? Colors.red : Colors.black,
//   ),
// ),
//
// ============================================================================
// BLOQUE 22 - RECETAS DE DART
// ============================================================================
//
// ---------------------------------------------------------------------------
// SI PIDEN CREAR UNA CLASE
// ---------------------------------------------------------------------------
//
// class Producto {
//   String nombre;
//   double precio;
//
//   Producto(this.nombre, this.precio);
//
//   void mostrar() {
//     print('$nombre cuesta $precio');
//   }
// }
//
// Crear un objeto:
//
// Producto producto = Producto('Teclado', 25.0);
//
// Ejecutar un método:
//
// producto.mostrar();
//
// ---------------------------------------------------------------------------
// SI PIDEN UNA CLASE ABSTRACTA
// ---------------------------------------------------------------------------
//
// abstract class Figura {
//   double calcularArea();
// }
//
// class Rectangulo extends Figura {
//   double base;
//   double altura;
//
//   Rectangulo(this.base, this.altura);
//
//   @override
//   double calcularArea() {
//     return base * altura;
//   }
// }
//
// ---------------------------------------------------------------------------
// SI PIDEN UNA EXCEPCIÓN PERSONALIZADA
// ---------------------------------------------------------------------------
//
// class MiExcepcion implements Exception {
//   final String mensaje;
//
//   MiExcepcion(this.mensaje);
//
//   @override
//   String toString() => mensaje;
// }
//
// Para lanzarla:
//
// throw MiExcepcion('Ha ocurrido un error');
//
// Para capturarla:
//
// try {
//   // Código que puede fallar.
// } catch (e) {
//   print(e);
// }
//
// ---------------------------------------------------------------------------
// SI PIDEN MAP
// ---------------------------------------------------------------------------
//
// Map<String, int> notas = {
//   'Ana': 8,
//   'Luis': 6,
// };
//
// Acceder:
//
// print(notas['Ana']);
//
// Añadir:
//
// notas['Marta'] = 9;
//
// ---------------------------------------------------------------------------
// SI PIDEN FILTER EN DART
// ---------------------------------------------------------------------------
//
// En Dart se utiliza where:
//
// List<int> numeros = [1, 2, 3, 4, 5];
//
// final pares = numeros.where(
//   (n) => n % 2 == 0,
// ).toList();
//
// ---------------------------------------------------------------------------
// SI PIDEN MAPEAR UNA LISTA
// ---------------------------------------------------------------------------
//
// List<int> numeros = [1, 2, 3];
//
// final dobles = numeros.map(
//   (n) => n * 2,
// ).toList();
//
// ============================================================================
// BLOQUE 23 - RESUMEN DE SINTAXIS
// ============================================================================
//
// =       Asignación.
// ==      Igualdad.
// !=      Diferencia.
// >       Mayor que.
// <       Menor que.
// >=      Mayor o igual.
// <=      Menor o igual.
// &&      Y lógico.
// ||      O lógico.
// !       Negación booleana o afirmación no-null.
// =>      Devuelve una expresión.
// :       Asocia parámetros nombrados con valores.
// ;       Final de instrucción.
// ()      Parámetros, argumentos y llamadas.
// {}      Bloques de código y otros usos.
// []      Listas y acceso por índice.
// <T>     Tipo genérico.
// ?       Tipo nullable u operador ternario.
// ??      Valor alternativo si hay null.
// ?.      Acceso seguro si el objeto puede ser null.
//
// final:
// Variable que no puede reasignarse.
//
// const:
// Valor constante en tiempo de compilación.
//
// required:
// Parámetro nombrado obligatorio.
//
// return:
// Devuelve un valor o termina un método.
//
// @override:
// Sobrescribe un miembro heredado.
//
// extends:
// Hereda de una clase.
//
// implements:
// Declara que se implementa una interfaz.
//
// setState():
// Actualiza el estado de la interfaz.
//
// initState():
// Inicialización del State.
//
// dispose():
// Liberación de recursos.
//
// async:
// Permite operaciones asíncronas.
//
// await:
// Espera el resultado de un Future.
//
// Future<T>:
// Resultado de una operación asíncrona.
//
// try/catch:
// Manejo de excepciones.
//
// child:
// Un widget hijo.
//
// children:
// Lista de widgets hijos.
//
// Row:
// Distribución horizontal.
//
// Column:
// Distribución vertical.
//
// Expanded:
// Ocupa el espacio disponible.
//
// Scaffold:
// Estructura de pantalla.
//
// AppBar:
// Barra superior.
//
// Text:
// Muestra texto.
//
// TextField:
// Entrada de texto.
//
// TextFormField:
// Entrada de texto con validación.
//
// ListView.builder:
// Lista dinámica.
//
// GridView.builder:
// Cuadrícula dinámica.
//
// Navigator.push:
// Abre una pantalla.
//
// Navigator.pop:
// Vuelve a la anterior.
//
// Navigator.pushReplacement:
// Sustituye la pantalla actual.
//
// ============================================================================
// FIN DEL ARCHIVO DE ESTUDIO
// ============================================================================
