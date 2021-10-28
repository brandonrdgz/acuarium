import 'package:acuarium/componentes/menu.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/negocio/menu_negocio_drawer.dart';
import 'package:flutter/material.dart';

class PaginaPrincipalNegocioPantalla extends StatelessWidget {
  static const String id = 'PaginaPrincipalNegocio';
  const PaginaPrincipalNegocioPantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acuarium')),
      drawer: MenuNegocioDrawer(
        nombreEncabezado: 'Negocio\nJuan',
        correoEncabezado: 'juan@negocio.com',
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 15.0,),
          Text(
            'Bienvenido Negocio',
            style: TextStyle(
              fontSize: 30.0
            ),
          ),
          Divider(
            color: Colors.blue,
            thickness: 1.0,
          ),
          Text(
            'Últimos pedidos',
            style: TextStyle(
              fontSize: 25.0
            ),
          ),
          Tarjeta(
            color: Colors.white,
            contenido: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      "1",
                      style: TextStyle(
                        fontSize: 10.0
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Número de peces: 2'),
                        Text('Total: \$300')
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
          Tarjeta(
            color: Colors.white,
            contenido: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      "2",
                      style: TextStyle(
                        fontSize: 10.0
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Número de peces: 1'),
                        Text('Total: \$150')
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
          Tarjeta(
            color: Colors.white,
            contenido: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      "3",
                      style: TextStyle(
                        fontSize: 10.0
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Número de peces: 3'),
                        Text('Total: \$450')
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}