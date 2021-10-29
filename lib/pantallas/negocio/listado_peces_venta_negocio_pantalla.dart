import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/negocio/agregar_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/editar_pez_pantalla.dart';
import 'package:acuarium/pantallas/negocio/informacion_pez_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListadoPecesVentaNegocioPantalla extends StatelessWidget {
  static const String id = 'ListadoPecesVentaNegocioPantalla';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Peces en venta'),),
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
                        subtitle: Text('Precio: \$150\nCantidad: 4\nEstado: Disponible'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(context, InformacionPezPantalla.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.solidEdit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(context, EditarPezPantalla.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.trash, color: Colors.blue),
                            onPressed: () {
                              Dialogo.dialogo(
                                context,
                                titulo: Text('Atención'),
                                contenido: Text('¿Está seguro de eliminar Especie 1?'),
                                acciones: <Widget>[
                                  TextButton(
                                    child: Text('Si'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ]
                              );
                            },
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
                        subtitle: Text('Precio: \$200\nCantidad: 4\nEstado: Disponible'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.solidEdit, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.trash, color: Colors.blue),
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
                        subtitle: Text('Precio: \$150\nCantidad: 4\nEstado: Disponible'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.solidEdit, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.trash, color: Colors.blue),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          Navigator.pushNamed(context, AgregarPezPantalla.id);
        },
      ),
    );
  }
}