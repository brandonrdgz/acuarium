import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore {
  static const String _coleccionDirecciones= 'direcciones';
  static const String _coleccionUsuarios= 'usuarios';
  static const String _coleccionTanques= 'tanques';
  static const String _coleccionPecesTanque= 'peces';
  static const String _coleccionModulos= 'modulos';
  static const String _campoNombre= 'nombre';

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

        static Stream<QuerySnapshot<Map<String, dynamic>>> listaTanques({
    required String uid,
  }) {
    return  FirebaseFirestore.instance.collection(_coleccionUsuarios).doc(uid).collection(_coleccionTanques).snapshots();
    
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> listaPecesTanque({
    required String uid,
    required String tid,
  }) {
    return  FirebaseFirestore.instance.collection(_coleccionUsuarios).doc(uid).collection(_coleccionTanques).doc(tid).collection(_coleccionPecesTanque).snapshots();
    
  }
    static Future<void> eliminaTanque({
    required String uid,
    required String rid,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionTanques)
                              .doc(rid)
                              .delete();

  }

  static Future<void> eliminaPezdeTanque({
    required String uid,
    required String tid,
    required String pid,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionTanques)
                              .doc(tid)
                              .collection(_coleccionPecesTanque)
                              .doc(pid)
                              .delete();

  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> datosModulo({
    required String mid,
  }) {
    return  FirebaseFirestore.instance.collection(_coleccionModulos).doc(mid).snapshots();
    
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> datosTanque({
    required String uid,
    required String tid,
  }) {
    return  FirebaseFirestore.instance
                            .collection(_coleccionUsuarios)
                            .doc(uid)
                            .collection(_coleccionTanques)
                            .doc(tid)
                            .snapshots();
    
  }
    static Stream<DocumentSnapshot<Map<String, dynamic>>> datosDireccion({
    required String uid,
    required String did,
  }) {
    return  FirebaseFirestore.instance
                            .collection(_coleccionUsuarios)
                            .doc(uid)
                            .collection(_coleccionDirecciones)
                            .doc(did)
                            .snapshots();
    
  }
    static Stream<DocumentSnapshot<Map<String, dynamic>>> datosPezdeTanque({
    required String uid,
    required String tid,
    required String pid,
  }) {
    return  FirebaseFirestore.instance
                            .collection(_coleccionUsuarios)
                            .doc(uid)
                            .collection(_coleccionTanques)
                            .doc(tid)
                            .collection(_coleccionPecesTanque)
                            .doc(pid)
                            .snapshots();
    
  }

  static Future<DocumentReference<Object?>> registroTanque({
    required String uid,
    required Map<String, dynamic> datos,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionTanques)
                              .add(datos);
  }

    static Future<DocumentReference<Object?>> registroPezdeTanque({
    required String uid,
    required String tid,
    required Map<String, dynamic> datos,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionTanques)
                              .doc(tid)
                              .collection(_coleccionPecesTanque)
                              .add(datos);
  }

  static Future<void> actualizaPezdeTanque({
    required String uid,
    required String tid,
    required String pid,
    required Map<String, dynamic> datos,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionTanques)
                              .doc(tid)
                              .collection(_coleccionPecesTanque)
                              .doc(pid)
                              .update(datos);
  }
  
  static Future<void> actualizaTanque({
    required String uid,
    required String tid,
    required Map<String, dynamic> datos,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionTanques)
                              .doc(tid)
                              .update(datos);
  }

    static Future<void> intervaloAlimentacion({
    required String mid,
    required double interValoHoras,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionModulos)
                              .doc(mid)
                              .update({
                                'intervaloAlimentacion':interValoHoras,
                              });
  }

}