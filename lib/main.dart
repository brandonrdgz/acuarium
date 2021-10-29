import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
import 'package:acuarium/pantallas/inicio.dart';
import 'package:acuarium/pantallas/inicio_sesion_pantalla.dart';
import 'package:acuarium/pantallas/negocio/pagina_principal_negocio_pantalla.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final User? _usuario = FirebaseAuth.instance.currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Inicio(rutaInicial: await _obtenRutaInicial(),));
}

Future<String> _obtenRutaInicial() async {
  String ruta = InicioSesionPantalla.id;

  if (_usuario != null) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');

    await usuarios.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        if (doc['correo'] == _usuario!.email) {
          if (doc['tipo'] == 'Cliente') {
            ruta = PaginaPrincipalClientePantalla.id;
          }
          else {
            ruta = PaginaPrincipalNegocioPantalla.id;
          }
        }
      });
    });
  };

  return ruta;
}