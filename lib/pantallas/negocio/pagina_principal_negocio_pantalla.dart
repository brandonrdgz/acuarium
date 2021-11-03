import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/negocio/menu_negocio_drawer.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:flutter/material.dart';

class PaginaPrincipalNegocioPantalla extends StatefulWidget {
  static const String id = 'PaginaPrincipalNegocio';
  const PaginaPrincipalNegocioPantalla({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipalNegocioPantalla> createState() => _PaginaPrincipalNegocioPantallaState();
}

class _PaginaPrincipalNegocioPantallaState extends State<PaginaPrincipalNegocioPantalla> {
  String? _urlImagenPerfil;
  String _nombreNegocio = '';
  String _nombre = '';
  String _correo = '';

  @override
  void initState() {
    super.initState();
    iniDatosEncabezadoDrawer();
  }

  void iniDatosEncabezadoDrawer() async {
    _urlImagenPerfil = await Storage.obtenURLImagen('perfil');
    _nombreNegocio = await Firestore.obtenNombreNegocio();
    _nombre = await Firestore.obtenNombre();
    _correo = await Firestore.obtenCorreo();

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acuarium')),
      drawer: MenuNegocioDrawer(
        imagenEncabezado: _urlImagenPerfil != null ? NetworkImage(_urlImagenPerfil!) : null,
        nombreEncabezado: '$_nombreNegocio\n$_nombre',
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