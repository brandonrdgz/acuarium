import 'dart:io';

import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
import 'package:acuarium/pantallas/inicio_sesion_pantalla.dart';
import 'package:acuarium/pantallas/negocio/pagina_principal_negocio_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:acuarium/utilidades/constantes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class RegistroPantalla extends StatefulWidget {
  static const String id = 'RegistroPantalla';

  RegistroPantalla({Key? key}) : super(key: key);

  @override
  _RegistroPantallaState createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final FirebaseAuth _aut = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _ultImagen;
  String _msjErrorImagenNoSeleccionada = '';
  final Icon _iconoCamara = Icon(Icons.camera_enhance_rounded);
  String _nombre = '';
  TextEditingController _controladorFechaNac = TextEditingController();
  late DateTime _ultFechaSeleccionada;
  String _fechaNac = '';
  String _correo = '';
  String _contrasenia = '';
  bool _muestraContrasenia = false;
  IconData _iconoAlternaContrasenia = FontAwesomeIcons.eye;
  bool _esNegocio = false;
  String _nombreNegocio = '';

  @override
  void initState() {
    super.initState();
    _ultFechaSeleccionada = DateTime(DateTime.now().year - 15);
  }

  @override
  void dispose() {
    _controladorFechaNac.dispose();

    super.dispose();
  }

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
                      InkWell(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 50.0,
                            child: _ultImagen != null ? null : _iconoCamara,
                            backgroundImage: _ultImagen != null ? FileImage(File(_ultImagen!.path)) : null,
                          ),
                        ),
                        onTap: _muestraModalInferiorSeleccionarImagen,
                      ),
                      Text(
                        _msjErrorImagenNoSeleccionada,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15
                        ),
                      ),
                      RoundedIconTextFormField(
                        labelText: 'Nombre',
                        prefixIcon: FontAwesomeIcons.user,
                        keyboardType: TextInputType.name,
                        onChanged: (String nombre) {
                          setState(() {
                            _nombre = nombre;
                          });
                        },
                        validator: (String? nombre) {
                          if (nombre == null || nombre.isEmpty) {
                            return 'El nombre no es válido';
                          }
                        }
                      ),
                      RoundedIconTextFormField(
                        labelText: 'Fecha de nacimiento',
                        prefixIcon: FontAwesomeIcons.calendar,
                        readOnly: true,
                        controller: _controladorFechaNac,
                        validator: (String? fecha) {
                          if (fecha == null || fecha.isEmpty) {
                            return 'La fecha no es válida';
                          }
                        },
                        onTap: _seleccionaFecha,
                      ),
                      RoundedIconTextFormField(
                        labelText: 'Correo electrónico',
                        prefixIcon: FontAwesomeIcons.envelope,
                        onChanged: (String correo) {
                          setState(() {
                            _correo = correo;
                          });
                        },
                        validator: (String? correo) {
                          if (correo == null || ! EmailValidator.validate(correo)) {
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
                          if (contrasenia == null || !Constantes.EXP_REG_CONTRASENIA.hasMatch(contrasenia)) {
                            return 'La contraseña debe de tener una longitud mínima de 6 caracteres, '
                            'contener al menos una minúscula, una mayúscula, un número y un caracter '
                            'especial .-*#\$&';
                          }
                        }
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Negocio'),
                          Switch(
                            value: _esNegocio,
                            onChanged: (bool value) {
                              setState(() {
                                _esNegocio = value;
                              });
                            },
                          ),
                        ],
                      ),
                      RoundedIconTextFormField(
                        enabled: _esNegocio,
                        labelText: 'Nombre de negocio',
                        prefixIcon: FontAwesomeIcons.store,
                        onChanged: (String nombreNegocio) {
                          setState(() {
                            _nombreNegocio = nombreNegocio;
                          });
                        },
                        validator: (String? nombreNegocio) {
                          if (_esNegocio && (nombreNegocio == null || nombreNegocio.isEmpty)) {
                            return 'El nombre de negocio no es válido';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '¿Ya tienes cuenta? ',
                              style: TextStyle(
                                fontSize: 16,
                              )
                            ),
                            GestureDetector(
                              child: Text(
                                'Inicia sesión',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, InicioSesionPantalla.id);
                              },
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        child: const Text(
                          'Registrarse',
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
                        onPressed: _registrarse
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

  void _muestraModalInferiorSeleccionarImagen() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0)
        )
      ),
      builder: (context) {
        return Wrap(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Imagen de perfil')
              ],
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    _iconoCamara,
                    Text('Cámara')
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _escogerImagen(ImageSource.camera);
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.photoVideo),
                    Text('Galería')
                  ],
                )
              ),
              onTap: () {
                Navigator.pop(context);
                _escogerImagen(ImageSource.gallery);
              },
            )
          ],
        );
      }
    );
  }

  void _escogerImagen(ImageSource source) async {
    XFile? imagenActual = await _imagePicker.pickImage(source: source);

    if (imagenActual != null) {
      setState(() {
        _ultImagen = imagenActual;
        _msjErrorImagenNoSeleccionada = '';
      });
    }
    else {
      setState(() {
        _msjErrorImagenNoSeleccionada = 'Debe de escoger o tomar una fotografía';
      });
    }
  }

  void _seleccionaFecha() async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      initialDate: _ultFechaSeleccionada,
      lastDate: DateTime(DateTime.now().year - 15, 12, 31),
      helpText: 'Selecciona una fecha',
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _ultFechaSeleccionada = fechaSeleccionada;
        _fechaNac = '${fechaSeleccionada.day.toString().padLeft(2, "0")}/'
          '${fechaSeleccionada.month.toString().padLeft(2, "0")}/'
          '${fechaSeleccionada.year.toString()}';
        _controladorFechaNac.text = _fechaNac;
      });
    }
  }

  void _registrarse() {
    if (_ultImagen != null && _formKey.currentState != null && _formKey.currentState!.validate()) {
      _muestraDialogoProgreso();
    }

    if (_ultImagen == null) {
      setState(() {
        _msjErrorImagenNoSeleccionada = 'Debe de escoger o tomar una fotografía';
      });
    }
  }

  void _muestraDialogoProgreso() async {
    String uidUsuario = '';
    Future future = tareaRegistro(uidUsuario);

    await Dialogo.dialogoProgreso(
      context,
      titulo: const Text('Registro'),
      contenido: const Text('Registrando. Espere por favor'),
      future: future,
      alTerminar: (valor) {
        _muestraDialogoResultado(
          titulo: const Icon(Icons.check_circle, color: Colors.green),
          contenido: const Text('Registro exitoso'),
          alAceptar: () {
            Navigator.pop(context);

            if (_esNegocio) {
              Navigator.pop(context);
              Navigator.pushNamed(context, PaginaPrincipalNegocioPantalla.id);
            }
            else {
              Navigator.pop(context);
              Navigator.pushNamed(context, PaginaPrincipalClientePantalla.id);
            }
          }
        );
      },
      enError: (error) {
        String msjError = Constantes.mensjeError(error);

        _muestraDialogoResultado(
          titulo: const Icon(Icons.close, color: Colors.red),
          contenido: Text(msjError),
          alAceptar: () {
            Navigator.pop(context);
          }
        );
      }
    );
  }

  Future tareaRegistro(String uidUsuario) {
    return Auth.registrar(
      correo: _correo,
      contrasenia: _contrasenia
    )
    .then(
      (UserCredential userCredential) async {
        if (userCredential.user != null) {
          uidUsuario = userCredential.user!.uid;

          await tareaSubirImagenPerfil(uidUsuario);
        }
      }
    );
  }

  Future tareaSubirImagenPerfil(String uidUsuario) {
    return Storage.subirImagenPerfil(File(_ultImagen!.path))!
    .then(
      (TaskSnapshot snapshot) async {
        await tareaRegistroDatosUsuario(uidUsuario);
      }
    );
  }

  Future<void> tareaRegistroDatosUsuario(String uidUsuario) {
    return Firestore.registroUsuario(
      uid: uidUsuario,
      imagen: 'perfil',
      nombre: _nombre,
      correo: _correo,
      fechaNac: _fechaNac,
      tipo: _esNegocio ? 'Negocio' : 'Cliente',
      nombreNegocio: _nombreNegocio
    );
  }

  void _muestraDialogoResultado({required Widget titulo, required Widget contenido, required VoidCallback alAceptar}) {
    Dialogo.dialogo(
      context,
      titulo: titulo,
      contenido: contenido,
      acciones: <Widget>[
        TextButton(
          child: const Text('Aceptar'),
          onPressed: alAceptar,
        )
      ]
    );
  }
}