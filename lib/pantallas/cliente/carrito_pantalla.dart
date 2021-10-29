import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/cliente/confirmacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CarritoPantalla extends StatelessWidget {
static const String id = 'CarritoPantalla';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrito')),
            drawer: MenuClienteDrawer(
        nombreEncabezado: 'Cliente',
        correoEncabezado: 'cliente@cliente.com',
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Tarjeta(
                  color: Colors.white,
                  contenido: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(FontAwesomeIcons.fish,)
                        ),
                        title: Text('Especie 1'),
                        subtitle: Text('Cantidad: 1\n\$150'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.minusCircle, color: Colors.blue),
                            onPressed: () {},
                          )
                        ]
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
                          child: Icon(FontAwesomeIcons.fish,)
                        ),
                        title: Text('Especie 2'),
                        subtitle: Text('Cantidad: 1\n\$200'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.minusCircle, color: Colors.blue),
                            onPressed: () {},
                          )
                        ]
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
                          child: Icon(FontAwesomeIcons.fish,)
                        ),
                        title: Text('Especie 3'),
                        subtitle: Text('Cantidad: 1\n\$150'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.minusCircle, color: Colors.blue),
                            onPressed: () {},
                          )
                        ]
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$500',
                    style: TextStyle(
                      fontSize: 20.0
                    ),
                  ),
                ),
              ]
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.moneyCheckAlt),
        tooltip: 'Proceder al pago',
        onPressed: () {
          Navigator.pushNamed(
            context,
            ConfirmacionPedidoClientePantalla.id
          );
        }
      ),
    );
  }
}