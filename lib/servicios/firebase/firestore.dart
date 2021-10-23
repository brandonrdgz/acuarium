import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static Future<DocumentReference<Object?>> registroUsuario({required String correo, required String tipo}) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');

    return usuarios.add({
      'correo': correo,
      'tipo': tipo
    });
  }

  static Future<DocumentReference<Object?>> registroDatosUsuario({
    required String correo,
    required String nombre,
    required String fechaNac,
  }) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('datosUsuarios');

    return usuarios.add({
      'correo': correo,
      'nombre': nombre,
      'fechaNac': fechaNac
    });
  }

  static Future<DocumentReference<Object?>> registroDatosInicialesNegocio({
    required String correo,
    required String nombreNegocio,
  }) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('datosNegocios');

    return usuarios.add({
      'correo': correo,
      'nombreNegocio': nombreNegocio,
    });
  }
}