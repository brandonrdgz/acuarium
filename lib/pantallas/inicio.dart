import 'package:acuarium/pantallas/cliente/acerca_de_pantalla.dart';
import 'package:acuarium/pantallas/cliente/carrito_pantalla.dart';
import 'package:acuarium/pantallas/cliente/confirmacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_pez_venta_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_peces_venta_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_pedidos_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/visor_ar_pantalla.dart';
import 'package:acuarium/pantallas/negocio/agregar_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/editar_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/informacion_pedido_negocio_pantalla.dart';
import 'package:acuarium/pantallas/negocio/informacion_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/listado_peces_venta_negocio_pantalla.dart';
import 'package:acuarium/pantallas/negocio/listado_pedidos_pantalla.dart';
import 'package:acuarium/pantallas/negocio/pagina_principal_negocio_pantalla.dart';
import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
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
  final String rutaInicial;
  Inicio({required this.rutaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: rutaInicial,
      routes: {
        InicioSesionPantalla.id: (context) => InicioSesionPantalla(),
        RegistroPantalla.id: (context) => RegistroPantalla(),
        PaginaPrincipalClientePantalla.id: (context) => PaginaPrincipalClientePantalla(),
        PaginaPrincipalNegocioPantalla.id: (context) => PaginaPrincipalNegocioPantalla(),
        Tanques.id: (context) => Tanques(),
        TanqueVista.id: (context) => TanqueVista(),
        TanqueNuevo.id:(context)=>TanqueNuevo(),
        TanqueEditar.id:(context)=>TanqueEditar(),
        PecesTanque.id:(context)=>PecesTanque(),
        PezTanque.id:(context)=>PezTanque(),
        AcercaDe.id:(context)=>AcercaDe(),
        NuevoPezTanque.id:(context)=>NuevoPezTanque(),
        EditarPezTanque.id:(context)=>EditarPezTanque(),
        DireccionesLista.id:(context)=>DireccionesLista(),
        DireccionVista.id:(context)=>DireccionVista(),
        NuevaDireccion.id:(context)=>NuevaDireccion(),
        EditarDireccion.id:(context)=>EditarDireccion(),
        ListadoPedidosClientePantalla.id: (context) => ListadoPedidosClientePantalla(),
        InformacionPedidoClientePantalla.id: (context) => InformacionPedidoClientePantalla(),
        ListadoPecesVentaClientePantalla.id: (context) => ListadoPecesVentaClientePantalla(),
        InformacionPezVentaPantalla.id: (context) => InformacionPezVentaPantalla(),
        CarritoPantalla.id: (context) => CarritoPantalla(),
        ConfirmacionPedidoClientePantalla.id: (context) => ConfirmacionPedidoClientePantalla(),
        ListadoPecesVentaNegocioPantalla.id: (context) => ListadoPecesVentaNegocioPantalla(),
        AgregarPezPantalla.id: (context) => AgregarPezPantalla(),
        EditarPezPantalla.id: (context) => EditarPezPantalla(),
        InformacionPezPantalla.id: (context) => InformacionPezPantalla(),
        ListadoPedidosNegocioPantalla.id: (context) => ListadoPedidosNegocioPantalla(),
        InformacionPedidoNegocioPantalla.id: (context) => InformacionPedidoNegocioPantalla(),
        VisorAr.id:(context)=>VisorAr(),
      },
    );
  }
}


