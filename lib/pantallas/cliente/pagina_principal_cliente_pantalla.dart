import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:flutter/material.dart';

class PaginaPrincipalClientePantalla extends StatefulWidget {
  static const String id = 'PaginaPrincipalCliente';
  const PaginaPrincipalClientePantalla({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipalClientePantalla> createState() => _PaginaPrincipalClientePantallaState();
}

class _PaginaPrincipalClientePantallaState extends State<PaginaPrincipalClientePantalla> {
  String _nombre = '';
  String _correo = '';

  @override
  void initState() {
    super.initState();
    iniDatosEncabezadoDrawer();
  }

  void iniDatosEncabezadoDrawer() async {
    _nombre = await Firestore.obtenNombre();
    _correo = await Firestore.obtenCorreo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acuarium')),
      drawer: MenuClienteDrawer(
        nombreEncabezado: _nombre,
        correoEncabezado: _correo,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 15.0,),
          Text(
            'Bienvenido $_nombre',
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