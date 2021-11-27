import 'package:acuarium/componentes/lista_pedidos.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/componentes/video_comp.dart';
import 'package:acuarium/pantallas/negocio/menu_negocio_drawer.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

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
    late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
     _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
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
          AcuariumVideoPlayer(),
          Divider(
            color: Colors.blue,
            thickness: 1.0,
          ),
          PedidosLista(idUsuario: Auth.getUserId()!,esNegocio: true,), ],
      ),
    );
  }
}