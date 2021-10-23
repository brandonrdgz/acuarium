import 'package:flutter/material.dart';

class Tarjeta extends StatelessWidget {
  final Color color;
  final Widget contenido;

  const Tarjeta(
    {
      required this.color,
      required this.contenido
    }
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: color,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: contenido
      ),
    );
  }
}