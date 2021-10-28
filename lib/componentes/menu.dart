import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatelessWidget {
  final ImageProvider? imagenEncabezado;
  final String nombreEncabezado;
  final String correoEncabezado;
  final Color colorEncabezado;
  final List<Widget> elementosMenu;

  Menu({this.imagenEncabezado, required this.nombreEncabezado, required this.correoEncabezado, required this.colorEncabezado, required this.elementosMenu});

  @override
  Widget build(BuildContext context) {
    List<Widget> menu = [
      UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage: imagenEncabezado,
          child: imagenEncabezado == null ? Icon(FontAwesomeIcons.user) : null,
        ),
        accountName: Text(nombreEncabezado),
        accountEmail: Text(correoEncabezado)
      ),
    ];

    menu.addAll(elementosMenu);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: menu,
      ),
    );
  }
}