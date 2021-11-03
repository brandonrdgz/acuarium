import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
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