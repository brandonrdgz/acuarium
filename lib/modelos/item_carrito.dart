import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemCarrito{
  String _id='';
  String _idPez='';
  String _idNegocio='';
  Timestamp _fecha=Timestamp.now();
  int    _cantidad=0;
  double _precio=0.0;
  String _imgUrl='';
  String _nombre='';
  String _descripcion='';

  ItemCarrito();

  String get getId => _id;
  String get getIdPez => _idPez;
  String get getIdNegocio =>_idNegocio;
  Timestamp get getFecha => _fecha;
  int get getCantidad => _cantidad;
  double get getPrecio => _precio;
  String get getImgUrl => _imgUrl;
   String get getNombre => _nombre;
   String get getDescripcion => _descripcion;

  set setId(String i)=>_id=i;
  set setNombre(String i)=>_nombre=i;
  set setIdPez(String i)=>_idPez=i;
  set setIdNegocio(String  n)=>_idNegocio=n;
  set setFecha(Timestamp  c)=>_fecha=c;
  set setCantidad(int n)=>_cantidad=n;
  set setPrecio(double c)=>_precio=c;
  set setImgUrl(String m)=>_imgUrl=m;
  set setDescripcion(String m)=>_descripcion=m;
  
  static Map<String, dynamic> toMapFromControl(
    String nombre,
    String uid,
    String fid,
    String nid,
    String imgUrl,
    String descripcion,
    int cantidad,
    double precio,){
      Timestamp tmp = Timestamp.now();
        return {
                                'nombre':nombre,
                                'idPez':fid,
                                'descripcion':descripcion,
                                'idNegocio':nid,
                                'fecha':tmp,
                                'cantidad':cantidad,
                                'precio':precio,
                                'imgUrl':imgUrl
                              };
  } 

    ItemCarrito.fromSnapshot(DocumentSnapshot obj){
    this._id=obj.id;
    this._nombre=obj.get('nombre');
    this._idPez=obj.get('idPez');
    this._idNegocio=obj.get('idNegocio');
    this._fecha=obj.get('fecha');
    this._cantidad=obj.get('cantidad');
    this._precio=obj.get('precio');
    this._imgUrl=obj.get('imgUrl');
    this._descripcion=obj.get('descripcion');
  }


}