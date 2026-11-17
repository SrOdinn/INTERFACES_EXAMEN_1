import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'modelos/usuario.dart';
import 'widgets/imagen_remota.dart';
import 'ejercicio11.dart';

class Ejercicio19 extends StatelessWidget {
  const Ejercicio19({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('19. Crear cuenta')),
    body: FormularioRegistro(
      onRegistro: (usuario) {
        // Reemplazar evita volver al registro una vez creada la cuenta.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => Login19(usuario: usuario)),
        );
      },
    ),
  );
}

class Login19 extends StatefulWidget {
  final Usuario usuario;
  const Login19({super.key, required this.usuario});
  @override
  State<Login19> createState() => _Login19State();
}

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

  void entrar() {
    if (!formulario.currentState!.validate()) return;
    // Comparación local pedida por el ejercicio. No es autenticación real.
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
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: entrar, child: const Text('Entrar')),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class Foto {
  final String id, autor;
  const Foto(this.id, this.autor);
  String get imagen => 'https://picsum.photos/id/$id/600/400';
  factory Foto.fromJson(Map<String, dynamic> json) =>
      Foto(json['id'] as String, json['author'] as String);
}

class Perfil19 extends StatefulWidget {
  final Usuario usuario;
  const Perfil19({super.key, required this.usuario});
  @override
  State<Perfil19> createState() => _Perfil19State();
}

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
      if (mounted) setState(() => fotos = resultado);
    } catch (_) {
      if (mounted) {
        setState(
          () =>
              error = 'No se pudieron cargar las fotos. Comprueba la conexión.',
        );
      }
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Widget listado(List<Foto> datos) {
    if (cargando) return const Center(child: CircularProgressIndicator());
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
                  onPressed: () => setState(() {
                    if (!favoritos.add(foto.id)) favoritos.remove(foto.id);
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
