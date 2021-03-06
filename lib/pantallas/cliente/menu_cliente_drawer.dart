import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/menu.dart';
import 'package:acuarium/pantallas/cliente/acerca_de_pantalla.dart';
import 'package:acuarium/pantallas/cliente/carrito_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_direcciones_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_peces_venta_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_pedidos_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_tanques_pantalla.dart';
import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
import 'package:acuarium/pantallas/inicio_sesion_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuClienteDrawer extends StatelessWidget {
  final ImageProvider? imagenEncabezado;
  final String nombreEncabezado;
  final String correoEncabezado;

  const MenuClienteDrawer({this.imagenEncabezado, required this.nombreEncabezado, required this.correoEncabezado});

  @override
  Widget build(BuildContext context) {
    return Menu(
      imagenEncabezado: imagenEncabezado,
      nombreEncabezado: nombreEncabezado,
      correoEncabezado: correoEncabezado,
      colorEncabezado: Colors.blue,
      elementosMenu: <Widget>[
        ListTile(
          leading: Icon(FontAwesomeIcons.water),
          title: Text('Mis acuarios'),
                    onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              Tanques.id
            );
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.box),
          title: Text('Mis pedidos'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              ListadoPedidosClientePantalla.id
            );
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.mapMarkedAlt),
          title: Text('Mis direcciones'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              DireccionesLista.id
            );
          },
        ),
        Divider(
          color: Colors.blue,
          thickness: 1.0,
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.fish),
          title: Text('Mercado de peces'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              ListadoPecesVentaClientePantalla.id
            );
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.shoppingCart),
          title: Text('Carrito'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              CarritoPantalla.id
            );
          },
        ),
        Divider(
          color: Colors.blue,
          thickness: 1.0,
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.info),
          title: Text('Acerca de'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AcercaDe.id);
          },
        ),        
        ListTile(
          leading: Icon(FontAwesomeIcons.signOutAlt),
          title: Text('Salir'),
          onTap: () {
            Dialogo.dialogoProgreso(
              context,
              contenido: Text('Cerrando sesi??n'),
              future: Auth.cerrarSesion(),
              alTerminar: (valor) {
                Navigator.popUntil(context, ModalRoute.withName(PaginaPrincipalClientePantalla.id));
                Navigator.pop(context);
                Navigator.pushNamed(context, InicioSesionPantalla.id);
              },
              enError: (error) {

              }
            );
          },
        ),
      ],
    );
  }
}