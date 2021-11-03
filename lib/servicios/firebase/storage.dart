import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Storage{
 static const String _tanquesPath= 'tanques';
 static const String _imagenesPath= 'img';
 


   static Future<TaskSnapshot> guardaImagenTanque(
                                            {
                                              required String uid,
                                              required File img
                                              })  {
    final storageRF = FirebaseStorage.instance.ref('$_imagenesPath/$_tanquesPath/$uid');
    var id= new Uuid();
    var imgPath=id.v1()+".jpg";  
    return storageRF.child(imgPath).putFile(img).whenComplete(() => null);

   /* final UploadTask ts = storageRF.child(imgPath).putFile(img);
    var imageUrl = await (await ts).ref.getDownloadURL();   
    return {
      'imgUrl':imageUrl,
      'imPath':imgPath
    }; */
  }

}