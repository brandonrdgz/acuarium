import 'dart:core';
import 'dart:ffi';

import 'package:acuarium/modelos/pedido.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore {
  static const String _coleccionDirecciones= 'direcciones';
  static const String _coleccionUsuarios= 'usuarios';
  static const String _coleccionTanques= 'tanques';
  static const String _coleccionPecesTanque= 'peces';
  static const String _coleccionPecesVenta= 'pecesVenta';
  static const String _coleccionModulos= 'modulos';
  static const String _coleccionCarrito= 'carrito';
  static const String _coleccionPedidos= 'pedidos';
  static const String _coleccionItemPedido= 'items';
  static const String _campoNombre= 'nombre';
  static const String _campoNegocio= 'idNegocio';
  static const String _campoIdCliente= 'idCliente';
  static const String _campoDisponible= 'disponible';
  static const String _campoEstado= 'estado';
  static const String _campoComprobante= 'comprobante';
  static const String _campoIdPez= 'idPez';
  static const String _campoIdNegocios ='idNegocios';
  static const String _campoRazon ='razon';


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

  static Stream<QuerySnapshot<Map<String, dynamic>>> listaPecesVenta({
    required String uid,
  }) {
    return  FirebaseFirestore.instance.collection(_coleccionPecesVenta).where(_campoNegocio,isEqualTo: uid).snapshots();
    
  }

    static Stream<QuerySnapshot<Map<String, dynamic>>> listaPecesVentaCliente() {
    return  FirebaseFirestore.instance.collection(_coleccionPecesVenta).where(_campoDisponible,isEqualTo: true).snapshots();
    
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

    static Future<void> eliminaPezVenta({
    required String did,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPecesVenta)
                              .doc(did)
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
    static Stream<DocumentSnapshot<Map<String, dynamic>>> datosPezVenta({
    required String did,
  }) {
    return  FirebaseFirestore.instance
                            .collection(_coleccionPecesVenta)
                            .doc(did)
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

    static Future<DocumentReference<Object?>> registroPezVenta({
    required Map<String, dynamic> datos,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPecesVenta)
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
      static Future<void> actualizaPezVenta({
    required String pid,
    required Map<String, dynamic> datos,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPecesVenta)
                                      .doc(pid)
                                      .update(datos);
  }

  static Future<void> actualizaEstadoPezVenta({
    required String pid,
    required bool newState,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPecesVenta)
                                      .doc(pid)
                                      .update({
                                        _campoDisponible: newState,
                                      });
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

static Future<void> agregarCarrito({
    required String uid,
    required Map<String,dynamic> data,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionCarrito)
                              .add(data);
  }

  static Future<void> eliminarCarrito({
    required String uid,
    required String did,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionCarrito)
                              .doc(did)
                              .delete();
  }


  static Future<bool> enCarrito ({
    required String uid,
    required String did,
  }) async{
    return await FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionCarrito)
                              .doc(did)
                              .snapshots()
                              .isEmpty;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> datosCarrito({
    required String uid,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid)
                              .collection(_coleccionCarrito)
                              .snapshots();
  }

  static Future<DocumentReference<Map<String,dynamic>>> crearPedido({
    required Map<String,dynamic> data,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPedidos)
                              .add(data);
  }

    static Future<void> agregaItemPedido({
    required String id,
    required Map<String,dynamic> data,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPedidos)
                              .doc(id)
                              .collection(_coleccionItemPedido)
                              .add(data);
  }

    static Stream<QuerySnapshot<Map<String, dynamic>>> listaPedidosCliente({
    required String uid
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPedidos)
                              .where(_campoIdCliente, isEqualTo:uid )
                              .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> datosPedido( {required String pid}) {
    return FirebaseFirestore.instance.collection(_coleccionPedidos)
                              .doc(pid).snapshots();
  }

    static Stream<QuerySnapshot<Map<String, dynamic>>> listaItemsPedido( {required String pid}) {
    return FirebaseFirestore.instance.collection(_coleccionPedidos)
                              .doc(pid)
                              .collection(_coleccionItemPedido)
                              .snapshots();
  }

  static Future<void> actualizaEstadoPedido({
    required String pid,
    required int newState,
    String razon="",
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPedidos)
                                      .doc(pid)
                                      .update({
                                        _campoEstado: newState,
                                        _campoRazon:razon,
                                      });
  }

  static Future<void> actualizaComprobantePedido({
    required String pid,
    required Map<String,String> img,
  }) {
    return FirebaseFirestore.instance.collection(_coleccionPedidos)
                                      .doc(pid)
                                      .update({
                                        _campoComprobante: img,
                                        _campoEstado: Pedido.CLAVE_COMPROBANTE_SUBIDO,
                                      });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> listaPedidosNegocio({required String uid}) {
    return FirebaseFirestore.instance.collection(_coleccionPedidos)
                              .where(_campoIdNegocios, arrayContains: uid )
                              .snapshots();

  }

    static Stream<DocumentSnapshot<Map<String, dynamic>>> datosUsuario( {required String uid}) {
    return FirebaseFirestore.instance.collection(_coleccionUsuarios)
                              .doc(uid).snapshots();
  }

      static Stream<QuerySnapshot<Map<String, dynamic>>> listaPedidos({
    required bool esNegocio,
    required String uid
  }) {
    if(esNegocio){
          return FirebaseFirestore.instance.collection(_coleccionPedidos)
                              .where(_campoIdNegocios,arrayContains:uid )
                              .limit(3)
                              .snapshots();

    }else{
          return FirebaseFirestore.instance.collection(_coleccionPedidos)
                              .where(_campoIdCliente, isEqualTo:uid )
                              .limit(3)
                              .snapshots();

    }

  }
  
}