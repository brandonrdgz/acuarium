import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PezDeTanque{
  String _id='';
  String _idTanque='';
  String _nombre='';
  int _numero=0;
  String _ciudados='';
  String _urlImg='';



  PezDeTanque();

  String get getId => _id;
  String get getIdTanque => _idTanque;
  String get getNombre =>_nombre;
  int get getNumero => _numero;
  String get getCuidados => _ciudados;
  String get getImagen => _urlImg;
  
  set setId(String d)=>_id=d;
  set setIdTanque(String d)=>_idTanque=d;
  set setNombre(String n)=>_nombre=n;
  set setNumero(int n)=>_numero=n;
  set setCuidados(String c)=>_ciudados=c;
  set setImagen(String u)=>_urlImg=u;
  
  static Map<String, dynamic> toMapFromControl(String idTanque,
                                        TextEditingController nombreCont,
                                        TextEditingController numeroCont,
                                        TextEditingController cuidadosCont,
                                        String urlImg){
        return {
          'idTanque':idTanque,
          'nombre':nombreCont.text,
          'numero':numeroCont.text,
          'cuidados':cuidadosCont.text,
          'urlImg':urlImg,
          };
  } 

  PezDeTanque.map(String id,dynamic obj){
    this._id=id;
    this._idTanque=obj['idTanque'];
    this._nombre=obj['nombre'];
    this._numero=obj['numero'];
    this._ciudados=obj['cuidados'];
    this._urlImg=obj['urlImg'];
  }

    PezDeTanque.fromSnapshot(DocumentSnapshot obj){      
    this._id=obj.id;    
    this._idTanque=obj.get('idTanque');
    this._nombre=obj.get('nombre');
    this._numero=obj.get('numero');
    this._ciudados=obj.get('cuidados');
    this._urlImg=obj.get('urlImg');

  }


}