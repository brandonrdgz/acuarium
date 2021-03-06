import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
import 'package:acuarium/pantallas/negocio/pagina_principal_negocio_pantalla.dart';
import 'package:acuarium/pantallas/registro_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/utilidades/constantes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InicioSesionPantalla extends StatefulWidget {

  InicioSesionPantalla({Key? key}) : super(key: key);
  static const String id = 'InicioSesionPantalla';

  @override
  _InicioSesionPantallaState createState() => _InicioSesionPantallaState();
}

class _InicioSesionPantallaState extends State<InicioSesionPantalla> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _correo = '';
  String _contrasenia = '';
  bool _muestraContrasenia = false;
  IconData _iconoAlternaContrasenia = FontAwesomeIcons.eye;

  @override
  Widget build(BuildContext context) {
    return _construyePantalla();
  }

  Widget _construyePantalla() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[200],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/acuarium.png'),
              const Text(
                'Acuarium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0
                ),
              ),
              Tarjeta(
                color: Colors.white,
                contenido: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      RoundedIconTextFormField(
                        labelText: 'Correo electr??nico',
                        prefixIcon: FontAwesomeIcons.envelope,
                        onChanged: (String correo) {
                          setState(() {
                            _correo = correo;
                          });
                        },
                        validator: (String? correo) {
                          if (correo == null || correo.isEmpty) {
                            return 'El correo electr??nico no es v??lido';
                          }
                        }
                      ),
                      RoundedIconTextFormField(
                        labelText: 'Contrase??a',
                        prefixIcon: FontAwesomeIcons.key,
                        obscureText: !_muestraContrasenia,
                        suffixIcon: IconButton(
                          icon: Icon(_iconoAlternaContrasenia),
                          onPressed: () {
                            setState(() {
                              _muestraContrasenia = !_muestraContrasenia;
                              _iconoAlternaContrasenia = _muestraContrasenia ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye;
                            });
                          },
                        ),
                        onChanged: (String contrasenia) {
                          setState(() {
                            _contrasenia = contrasenia;
                          });
                        },
                        validator: (String? contrasenia) {
                          if (contrasenia == null || contrasenia.isEmpty) {
                            return 'La contrasenia no puede estar vac??a';
                          }
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '??No tienes cuenta? ',
                              style: TextStyle(
                                fontSize: 16,
                              )
                            ),
                            GestureDetector(
                              child: Text(
                                'Registrate',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, RegistroPantalla.id);
                              },
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        child: const Text(
                          'Iniciar sesi??n',
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade200),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)
                            )
                          ),
                        ),
                        onPressed: _iniciarSesion
                      ),
                     const SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              )
            ],
          ),
        ),
      )
    );
  }

  void _iniciarSesion() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _muestraDialogoInicioSesion();
    }
  }

  void _muestraDialogoInicioSesion() async {
    String ruta = '';

    Future future = Auth.iniciarSesion(
      correo: _correo,
      contrasenia: _contrasenia
    ).then((UserCredential userCredential) async {
      if (userCredential.user != null) {
        DocumentReference refDocUsuario = FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid);
        DocumentSnapshot snapshotUsuario = await refDocUsuario.get();

        if (snapshotUsuario.exists) {
          ruta = snapshotUsuario['tipo'] == 'Cliente' ? PaginaPrincipalClientePantalla.id : PaginaPrincipalNegocioPantalla.id;
        }
        else {
          throw Exception('Usuario/contrase??a no v??lidos');
        }
      }
      else {
        throw Exception('Usuario/contrase??a no v??lidos');
      }
    });

    await Dialogo.dialogoProgreso(
      context,
      titulo: const Text('Incio de sesi??n'),
      contenido: const Text('Iniciando sesi??n.'),
      future: future,
      alTerminar: (valor) {
        if (ruta.isNotEmpty) {
          Navigator.pop(context);
          Navigator.pushNamed(context, ruta);
        }
      },
      enError: (error) {
        String msjError = Constantes.mensjeError(error);

        Dialogo.dialogo(
          context,
          titulo: Icon(FontAwesomeIcons.timesCircle, color: Colors.red),
          contenido: Text(msjError),
          acciones: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]
        );
      }
    );
  }
}

