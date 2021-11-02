import 'package:cloud_firestore/cloud_firestore.dart';

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
}