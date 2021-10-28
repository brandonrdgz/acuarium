import 'dart:io';

import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditarPezPantalla extends StatefulWidget {
  static const String id = 'EditarPezPantalla';

  @override
  State<EditarPezPantalla> createState() => _EditarPezPantallaState();
}

class _EditarPezPantallaState extends State<EditarPezPantalla> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _ultImagen;
  final Icon _iconoCamara = Icon(Icons.camera_enhance_rounded);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar pez'),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.times),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Tarjeta(
          color: Colors.white,
          contenido: Column(
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
              RoundedIconTextFormField(
                labelText: 'Especie',
                prefixIcon: FontAwesomeIcons.fish,
                initialValue: 'Especie 1',
                validator: (String? especie) {}
              ),
              RoundedIconTextFormField(
                labelText: 'Número',
                prefixIcon: FontAwesomeIcons.hashtag,
                initialValue: '4',
                validator: (String? especie) {}
              ),
              RoundedIconTextFormField(
                labelText: 'Precio',
                prefixIcon: FontAwesomeIcons.moneyBillWave,
                prefixText: '\$',
                initialValue: '150',
                validator: (String? especie) {}
              ),
              RoundedIconTextFormField(
                labelText: 'Descripción',
                prefixIcon: FontAwesomeIcons.stickyNote,
                initialValue: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                maxLines: null,
                validator: (String? especie) {}
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.save),
        onPressed: () {},
      ),
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
                Text('Imagen de pez')
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
              onTap: () async {
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
              onTap: () async {
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
      });
    }
  }
}