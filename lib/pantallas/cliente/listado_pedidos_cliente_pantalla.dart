import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/cliente/informacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListadoPedidosClientePantalla extends StatelessWidget {
  static const String id = 'ListadoPedidosCliente';
  const ListadoPedidosClientePantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pedidos')),
            drawer: MenuClienteDrawer(
        nombreEncabezado: 'Cliente',
        correoEncabezado: 'cliente@cliente.com',
      ),
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
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Text>[
                            Text('ID: 0'),
                            Text('Número de peces: 3'),
                            Text('Total: \$500'),
                            Text('Estado: Por confirmar'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <IconButton>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue,),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                InformacionPedidoClientePantalla.id
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.ban, color: Colors.blue,),
                            onPressed: () {
          
                            },
                          )
                        ],
                      )
                    ],
                  )
                ),
                Tarjeta(
                  color: Colors.white,
                  contenido: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(FontAwesomeIcons.fish),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Text>[
                            Text('ID: 1'),
                            Text('Número de peces: 1'),
                            Text('Total: \$150'),
                            Text('Estado: Por confirmar'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <IconButton>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue,),
                            onPressed: () {
          
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.ban, color: Colors.blue,),
                            onPressed: () {
          
                            },
                          )
                        ],
                      )
                    ],
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}