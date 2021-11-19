import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage{
 static const String _tanquesPath= 'tanques';
 static const String _imagenesPath= 'img';
 static const String _pecesPath= 'peces';
 


   static Future<TaskSnapshot> guardaImagenTanque(
                                            {
                                              required String uid,
                                              required File img
                                              })  {
    final storageRF = FirebaseStorage.instance.ref('$_imagenesPath/$_tanquesPath/$uid');
    var id= new Uuid();
    var imgPath=id.v1()+".jpg";  
    return storageRF.child(imgPath).putFile(img).whenComplete(() => null);

  
  }

     static Future<TaskSnapshot> guardaImagenPezTanque(
                                            {
                                              required String uid,
                                              required File img
                                              })  {
    final storageRF = FirebaseStorage.instance.ref('$_imagenesPath/$_tanquesPath/$_pecesPath/$uid');
    var id= new Uuid();
    var imgPath=id.v1()+".jpg";  
    return storageRF.child(imgPath).putFile(img).whenComplete(() => null);

  
  }

     static Future<void> eliminaImagenTanque(
                                            {
                                              required String uid,
                                              required String name
                                              })  {
    final storageRF = FirebaseStorage.instance.ref('$_imagenesPath/$_tanquesPath/$uid/$name');
    return storageRF.delete();

  
  }

       static Future<void> eliminaImagenPezdeTanque(
                                            {
                                              required String uid,
                                              required String name
                                              })  {
    final storageRF = FirebaseStorage.instance.ref('$_imagenesPath/$_tanquesPath/$_pecesPath/$uid/$name');
    return storageRF.delete();

  
  }




  static UploadTask? subirImagenPerfil(File imagenPerfil) {
    User? usuario = FirebaseAuth.instance.currentUser;
    print(usuario);

    if (usuario != null) {
      Reference refImagen = FirebaseStorage.instance.ref('${usuario.uid}/perfil');
      return refImagen.putFile(imagenPerfil);
    }
  }

  static Future<String?> obtenURLImagen(String refImagen) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Reference refRuta = FirebaseStorage.instance.ref('${user.uid}/$refImagen');
      return refRuta.getDownloadURL();
    }
  }
}