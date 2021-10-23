import 'package:flutter/material.dart';

import 'inicio_sesion_pantalla.dart';
import 'registro_pantalla.dart';

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RegistroPantalla.id, //InicioSesionPantalla.id,
      routes: {
        InicioSesionPantalla.id: (context) => InicioSesionPantalla(),
        RegistroPantalla.id: (context) => RegistroPantalla(),

      },
    );
  }
}


