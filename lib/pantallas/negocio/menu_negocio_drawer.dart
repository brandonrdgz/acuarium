import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/menu.dart';
import 'package:acuarium/pantallas/inicio_sesion_pantalla.dart';
import 'package:acuarium/pantallas/negocio/listado_peces_venta_negocio_pantalla.dart';
import 'package:acuarium/pantallas/negocio/listado_pedidos_pantalla.dart';
import 'package:acuarium/pantallas/negocio/pagina_principal_negocio_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuNegocioDrawer extends StatelessWidget {
  final ImageProvider? imagenEncabezado;
  final String nombreEncabezado;
  final String correoEncabezado;

  const MenuNegocioDrawer({this.imagenEncabezado, required this.nombreEncabezado, required this.correoEncabezado});

  @override
  Widget build(BuildContext context) {
    return Menu(
      imagenEncabezado: imagenEncabezado,
      nombreEncabezado: nombreEncabezado,
      correoEncabezado: correoEncabezado,
      colorEncabezado: Colors.blue,
      elementosMenu: <Widget>[
        ListTile(
          leading: Icon(FontAwesomeIcons.fish),
          title: Text('Mis peces'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, ListadoPecesVentaNegocioPantalla.id);
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.box),
          title: Text('Mis pedidos'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, ListadoPedidosNegocioPantalla.id);
          }
        ),
        Divider(
          color: Colors.blue,
          thickness: 1.0,
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.signOutAlt),
          title: Text('Salir'),
          onTap: () {
            Dialogo.dialogoProgreso(
              context,
              contenido: Text('Cerrando sesión'),
              future: Auth.cerrarSesion(),
              alTerminar: (valor) {
                Navigator.popUntil(context, ModalRoute.withName(PaginaPrincipalNegocioPantalla.id));
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