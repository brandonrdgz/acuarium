import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
import 'package:acuarium/pantallas/negocio/pagina_principal_negocio_pantalla.dart';
import 'package:acuarium/pantallas/registro_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/utilidades/constantes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                        labelText: 'Correo electrónico',
                        prefixIcon: FontAwesomeIcons.envelope,
                        onChanged: (String correo) {
                          setState(() {
                            _correo = correo;
                          });
                        },
                        validator: (String? correo) {
                          if (correo == null) {
                            return 'El correo electrónico no es válido';
                          }
                        }
                      ),
                      RoundedIconTextFormField(
                        labelText: 'Contraseña',
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
                            return 'La contrasenia no puede estar vacía';
                          }
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '¿No tienes cuenta? ',
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
                          'Iniciar sesión',
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
      _muestraDialogoProgreso();
    }
  }

void _muestraDialogoProgreso() async {
    Future future = Auth.iniciarSesion(
      correo: _correo,
      contrasenia: _contrasenia
    ).then((value) async {
      CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');
      String? ruta;

      await usuarios.get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          if (doc['correo'] == _correo) {
            if (doc['tipo'] == 'Cliente') {
              ruta = PaginaPrincipalClientePantalla.id;
            }
            else {
              ruta =PaginaPrincipalNegocioPantalla.id;
            }
          }
        });
      });

      if (ruta == null) {
        throw Exception('El usuario no es válido');
      }

      return ruta;
    });

    await Dialogo.dialogoProgreso(
      context,
      titulo: const Text('Incio de sesión'),
      contenido: const Text('Iniciando sesión.'),
      future: future,
      alTerminar: (ruta) {
        Navigator.pop(context);
        Navigator.pushNamed(context, ruta);
      },
      enError: (error) {
        Dialogo.dialogo(
          context,
          titulo: Icon(FontAwesomeIcons.timesCircle, color: Colors.red),
          contenido: Text('Ocurrio un error al iniciar sesión'),
          acciones: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]
        );
        print(error);
      }
    );
  }
}

