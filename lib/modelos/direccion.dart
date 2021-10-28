import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Direccion{
  String _id='';
  String _idCliente='';
  String _nombre='';
  String _calle='';
  String _numero='';
  String _codigoPostal='';
  String _municipio='';
  String _estado='';
  double _lat=0.0;
  double _lng=0.0;

  Direccion();

  String get getId => _id;
  String get getidCliente => _idCliente;
  String get getNombre =>_nombre;
  String get getCalle => _calle;
  String get getNumero => _numero;
  String get getCodigoPostal => _codigoPostal;
  String get getMunicipio => _municipio;
  String get getEstado => _estado;
  double get getLat => _lat;
  double get getLng => _lng;

  set setId(String i)=>_id=i;
  set setIdCliente(String i)=>_idCliente=i;
  set setNombre(String  n)=>_nombre=n;
  set setCalle(String  c)=>_calle=c;
  set setNumero(String n)=>_numero=n;
  set setCodigoPostal(String c)=>_codigoPostal=c;
  set setMunicipio(String m)=>_municipio=m;
  set setEstado(String e)=>_estado=e;
  set setLat(double l)=>_lat=l;
  set setLng(double l)=>_lng=l;
  
  static Map<String, dynamic> toMapFromControl(String idCliente,
                                        TextEditingController nombreCont,
                                        TextEditingController calleCont,
                                        TextEditingController numeroCont,
                                        TextEditingController codigoPostalCont,
                                        TextEditingController municipioCont,
                                        TextEditingController estadoCont,
                                        GeoPoint posicion){
        return {
          'idCliente':idCliente,
          'nombre':nombreCont.text,
          'calle':calleCont.text,
          'numero':numeroCont.text,
          'codigoPostal':codigoPostalCont.text,
          'municipio':municipioCont.text,
          'estado':estadoCont.text,
          'posicion':posicion,
            };
  } 

  Direccion.map(String id,dynamic obj){
    this._id=id;
    this._idCliente=obj['idCliente'];
    this._nombre=obj['nombre'];
    this._calle=obj['calle'];
    this._numero=obj['numero'];
    this._codigoPostal=obj['codigoPostal'];
    this._municipio=obj['municipio'];
    this._estado=obj['estado'];
    this._lat=obj['lat'];
    this._lng=obj['lng'];
  }

    Direccion.fromSnapshot(DocumentSnapshot obj){
    this._id=obj.id;
    this._idCliente=obj.get('idCliente');
    this._nombre=obj.get('nombre');
    this._calle=obj.get('calle');
    this._numero=obj.get('numero');
    this._codigoPostal=obj.get('codigoPostal');
    this._municipio=obj.get('municipio');
    this._estado=obj.get('estado');
    GeoPoint p=obj.get('posicion');
    this._lat=p.latitude;
    this._lng=p.longitude;
  }


}