import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore {

  static Future<void> registroUsuario({
    required String uid,
    required String imagen,
    required String correo,
    required String nombre,
    String nombreNegocio = '',
    required String fechaNac,
    required String tipo
  }) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');
    Map<String, String> datos = {
      'imagen': imagen,
      'correo': correo,
      'nombre': nombre,
      'fechaNac': fechaNac,
      'tipo': tipo,
      if (tipo == 'Negocio') 'nombreNegocio': nombreNegocio,
    };

    return usuarios.doc(uid).set(datos);
  }

  static Future<String> obtenCorreo() async {
    User? usuario = FirebaseAuth.instance.currentUser;
    String correo = '';

    if (usuario != null) {
      DocumentReference refDocDatosUsuario = FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid);
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
      DocumentReference refDocDatosUsuario = FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid);
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
      DocumentReference refDocDatosNegocio = FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid);
      DocumentSnapshot snapshotDatosNegocio = await refDocDatosNegocio.get();

      if (snapshotDatosNegocio.exists) {
        nombreNegocio = snapshotDatosNegocio['nombreNegocio'];
      }
    }

    return nombreNegocio;
  }
}