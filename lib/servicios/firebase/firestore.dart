import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore {
  static Future<void> registroUsuario({required String uid, required String correo, required String tipo}) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');

    return usuarios.doc(uid).set({
      'correo': correo,
      'tipo': tipo
    });
  }

  static Future<void> registroDatosUsuario({
    required String uid,
    required String correo,
    required String nombre,
    required String fechaNac,
  }) {
    CollectionReference datosUsuarios = FirebaseFirestore.instance.collection('datosUsuarios');

    return datosUsuarios.doc(uid).set({
      'correo': correo,
      'nombre': nombre,
      'fechaNac': fechaNac
    });
  }

  static Future<void> registroDatosInicialesNegocio({
    required String uid,
    required String correo,
    required String nombreNegocio,
  }) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('datosNegocios');

    return usuarios.doc(uid).set({
      'correo': correo,
      'nombreNegocio': nombreNegocio,
    });
  }

  static Future<String> obtenCorreo() async {
    User? usuario = FirebaseAuth.instance.currentUser;
    String correo = '';

    if (usuario != null) {
      DocumentReference refDocDatosUsuario = FirebaseFirestore.instance.collection('datosUsuarios').doc(usuario.uid);
      DocumentSnapshot snapshotDatosUsuario = await refDocDatosUsuario.get();

      if (snapshotDatosUsuario.exists) {
        correo = snapshotDatosUsuario['correo'];
      }
    }

    return correo;
  }

  static Future<String> obtenNombre() async {
    User? usuario = FirebaseAuth.instance.currentUser;
    String nombre = '';

    if (usuario != null) {
      DocumentReference refDocDatosUsuario = FirebaseFirestore.instance.collection('datosUsuarios').doc(usuario.uid);
      DocumentSnapshot snapshotDatosUsuario = await refDocDatosUsuario.get();

      if (snapshotDatosUsuario.exists) {
        nombre = snapshotDatosUsuario['nombre'];
      }
    }

    return nombre;
  }

  static Future<String> obtenNombreNegocio() async {
    User? usuario = FirebaseAuth.instance.currentUser;
    String nombreNegocio = '';

    if (usuario != null) {
      DocumentReference refDocDatosNegocio = FirebaseFirestore.instance.collection('datosNegocios').doc(usuario.uid);
      DocumentSnapshot snapshotDatosNegocio = await refDocDatosNegocio.get();

      if (snapshotDatosNegocio.exists) {
        nombreNegocio = snapshotDatosNegocio['nombreNegocio'];
      }
    }

    return nombreNegocio;
  }
}