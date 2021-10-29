import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static const String _coleccionDirecciones= 'direcciones';
  static const String _coleccionUsuarios= 'usuarios';
  static const String _campoNombre= 'nombre';
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


    static Stream<QuerySnapshot<Map<String, dynamic>>> listaDirecciones({
    required String uid,
  }) {
    return  FirebaseFirestore.instance.collection(_coleccionUsuarios).doc(uid).collection(_coleccionDirecciones).snapshots();
    
  }

      static Stream<QuerySnapshot<Map<String, dynamic>>> listaDireccionesFiltrada({
    required String uid,
    required String cadena,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios).doc(uid).collection(_coleccionDirecciones).where(_campoNombre,isEqualTo: cadena).snapshots();
  }

    static Future<DocumentReference<Object?>> registroDireccion({
    required String uid,
    required Map<String, dynamic> datos,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionDirecciones)
                              .add(datos);

  }

  static Future<void> actualizaDireccion({
    required String uid,
    required String rid,
    required Map<String, dynamic> datos,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionDirecciones)
                              .doc(rid)
                              .update(datos);

  }

    static Future<void> eliminaDireccion({
    required String uid,
    required String rid,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionDirecciones)
                              .doc(rid)
                              .delete();

  }



}