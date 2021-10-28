import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/modelos/peces.dart';
import 'package:acuarium/modelos/tanque.dart';
import 'package:acuarium/pantallas/cliente/agregar_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/agregar_pez_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/agregar_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_pez_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/editar_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_direccion_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_pez_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_tanque_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_direcciones_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_peces_tanque_pantalla.dart';
import 'package:flutter/material.dart';

import 'cliente/listado_tanques_pantalla.dart';
import 'inicio_sesion_pantalla.dart';
import 'registro_pantalla.dart';

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: DireccionesLista.id, //InicioSesionPantalla.id,
      routes: {
        InicioSesionPantalla.id: (context) => InicioSesionPantalla(),
        RegistroPantalla.id: (context) => RegistroPantalla(),
        Tanques.id: (context) => Tanques(),
        TanqueVista.id: (context) => TanqueVista(),
        TanqueNuevo.id:(context)=>TanqueNuevo(),
        TanqueEditar.id:(context)=>TanqueEditar(),
        PecesTanque.id:(context)=>PecesTanque(),
        PezTanque.id:(context)=>PezTanque(),
        NuevoPezTanque.id:(context)=>NuevoPezTanque(),
        EditarPezTanque.id:(context)=>EditarPezTanque(),
        DireccionesLista.id:(context)=>DireccionesLista(),
        DireccionVista.id:(context)=>DireccionVista(),
        NuevaDireccion.id:(context)=>NuevaDireccion(),
        EditarDireccion.id:(context)=>EditarDireccion()
      },
    );
  }
}


