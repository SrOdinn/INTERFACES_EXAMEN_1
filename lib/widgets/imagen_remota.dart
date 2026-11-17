import 'package:flutter/material.dart';

class ImagenRemota extends StatelessWidget {
  final String url;
  final double ancho;
  final double alto;

  const ImagenRemota(
    this.url, {
    super.key,
    required this.ancho,
    required this.alto,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: ancho,
      height: alto,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;

        return SizedBox(
          width: ancho,
          height: alto,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: ancho,
          height: alto,
          child: const Center(child: Icon(Icons.broken_image)),
        );
      },
    );
  }
}
