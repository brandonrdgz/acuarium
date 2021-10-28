import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/cliente/informacion_pez_venta_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListadoPecesVentaClientePantalla extends StatelessWidget {
  static const String id = 'ListadoPecesVentaClientePantalla';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tienda'),),
      body: Column(
        children: <Widget>[
          RoundedIconTextFormField(
            labelText: 'Búsqueda',
            prefixIcon: FontAwesomeIcons.search,
            validator: null,
            onChanged: (String? busqueda) {

            },
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Tarjeta(
                  color: Colors.white,
                  contenido: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(FontAwesomeIcons.fish),
                        ),
                        title: Text('Especie 1'),
                        subtitle: Text('Precio: \$150'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                InformacionPezVentaPantalla.id
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.cartPlus, color: Colors.blue),
                            onPressed: () {},
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Tarjeta(
                  color: Colors.white,
                  contenido: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(FontAwesomeIcons.fish),
                        ),
                        title: Text('Especie 2'),
                        subtitle: Text('Precio: \$200'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.cartPlus, color: Colors.blue),
                            onPressed: () {},
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Tarjeta(
                  color: Colors.white,
                  contenido: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(FontAwesomeIcons.fish),
                        ),
                        title: Text('Especie 3'),
                        subtitle: Text('Precio: \$150'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.cartPlus, color: Colors.blue),
                            onPressed: () {},
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}