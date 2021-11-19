import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PezDeTanque{
  String _id='';
  String _idTanque='';
  String _idUsuario='';
  String _nombre='';
  int _numero=0;
  String _ciudados='';
 Map _imagen={};



  PezDeTanque();

  String get getId => _id;
  String get getIdTanque => _idTanque;
  String get getIdUsuario => _idUsuario;
  String get getNombre =>_nombre;
  int get getNumero => _numero;
  String get getCuidados => _ciudados;
  Map get getImagen => _imagen;
  
  set setId(String d)=>_id=d;
  set setIdTanque(String d)=>_idTanque=d;
  set setIdUsuario(String d)=>_idUsuario=d;
  set setNombre(String n)=>_nombre=n;
  set setNumero(int n)=>_numero=n;
  set setCuidados(String c)=>_ciudados=c;
  set setImagen(Map u)=>_imagen=u;
  
  static Map<String, dynamic> toMapFromControl(
                                        String uid,
                                        String idTanque,
                                        TextEditingController nombreCont,
                                        TextEditingController numeroCont,
                                        TextEditingController cuidadosCont,
                                        Map urlImg){
        return {
          'idUsuario':uid,
          'idTanque':idTanque,
          'nombre':nombreCont.text,
          'numero':numeroCont.text,
          'cuidados':cuidadosCont.text,
          'imagen':urlImg,
          };
  } 

  PezDeTanque.map(String id,dynamic obj){
    this._id=id;
    this._idTanque=obj['idTanque'];
    this._idUsuario=obj['idUsuario'];
    this._nombre=obj['nombre'];
    this._numero=obj['numero'];
    this._ciudados=obj['cuidados'];
    this._imagen=obj['imagen'];
  }

    PezDeTanque.fromSnapshot(DocumentSnapshot obj){      
    this._id=obj.id;    
    this._idTanque=obj.get('idTanque');
    this._idUsuario=obj.get('idUsuario');
    this._nombre=obj.get('nombre');
    this._numero= int.parse(obj.get('numero'));
    this._ciudados=obj.get('cuidados');
    this._imagen=obj.get('imagen');

  }


}