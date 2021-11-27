import 'package:acuarium/componentes/lista_pedidos.dart';
import 'package:acuarium/componentes/video_comp.dart';
import 'package:acuarium/pantallas/cliente/menu_cliente_drawer.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:flutter/material.dart';
class PaginaPrincipalClientePantalla extends StatefulWidget {
  static const String id = 'PaginaPrincipalCliente';
  const PaginaPrincipalClientePantalla({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipalClientePantalla> createState() => _PaginaPrincipalClientePantallaState();
}

class _PaginaPrincipalClientePantallaState extends State<PaginaPrincipalClientePantalla> {
  String? _urlImagenPerfil;
  String _nombre = '';
  String _correo = '';
  

  @override
  void initState() {
    super.initState();
    iniDatosEncabezadoDrawer();
  }


  void iniDatosEncabezadoDrawer() async {
    _urlImagenPerfil = await Storage.obtenURLImagen('perfil');
    _nombre = await Firestore.obtenNombre();
    _correo = await Firestore.obtenCorreo();

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acuarium')),
      drawer: MenuClienteDrawer(
        imagenEncabezado: _urlImagenPerfil != null ? NetworkImage(_urlImagenPerfil!) : null,
        nombreEncabezado: _nombre,
        correoEncabezado: _correo,
      ),
      body: SingleChildScrollView(
        child:Column(
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
          AcuariumVideoPlayer(),
          Divider(
            color: Colors.blue,
            thickness: 1.0,
          ),
          PedidosLista(idUsuario: Auth.getUserId()!,esNegocio: false,),
          ],
      ),
      )
    );
  }
}