import 'package:acuarium/pantallas/cliente/carrito_pantalla.dart';
import 'package:acuarium/pantallas/cliente/confirmacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/informacion_pez_venta_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_peces_venta_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_pedidos_cliente_pantalla.dart';
import 'package:acuarium/pantallas/negocio/agregar_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/editar_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/informacion_pedido_negocio_pantalla.dart';
import 'package:acuarium/pantallas/negocio/informacion_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/listado_peces_venta_negocio_pantalla.dart';
import 'package:acuarium/pantallas/negocio/listado_pedidos_pantalla.dart';
import 'package:acuarium/pantallas/negocio/pagina_principal_negocio_pantalla.dart';
import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
import 'package:flutter/material.dart';

import 'inicio_sesion_pantalla.dart';
import 'registro_pantalla.dart';

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: PaginaPrincipalNegocioPantalla.id,
      routes: {
        InicioSesionPantalla.id: (context) => InicioSesionPantalla(),
        RegistroPantalla.id: (context) => RegistroPantalla(),
        PaginaPrincipalClientePantalla.id: (context) => PaginaPrincipalClientePantalla(),
        PaginaPrincipalNegocioPantalla.id: (context) => PaginaPrincipalNegocioPantalla(),
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
      },
    );
  }
}


