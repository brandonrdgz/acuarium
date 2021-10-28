import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:flutter/material.dart';

class PaginaPrincipalClientePantalla extends StatelessWidget {
  static const String id = 'PaginaPrincipalCliente';
  const PaginaPrincipalClientePantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acuarium')),
      drawer: MenuClienteDrawer(
        nombreEncabezado: 'Cliente',
        correoEncabezado: 'cliente@cliente.com',
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 15.0,),
          Text(
            'Bienvenido Cliente',
            style: TextStyle(
              fontSize: 30.0
            ),
          ),
          Divider(
            color: Colors.blue,
            thickness: 1.0,
          ),
          Text(
            'Últimos tanques',
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
                        Text('Tanque0'),
                        Text('Litros: 125.0')
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
                        Text('Tanque1'),
                        Text('Litros: 125.0')
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
                        Text('Tanque3'),
                        Text('Litros: 125.0')
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