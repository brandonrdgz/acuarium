import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Modulo{
  String _id='';
  double _temperatura=0.0;
  Timestamp _ultimaLectura=Timestamp.now();
  double _intervaloAlimentacion=0.0;
  Timestamp _ultimaComida=Timestamp.now();

  Modulo();

  String get getId => _id;
  double get getTemperatura => _temperatura;
  Timestamp get getUltimaLectura =>_ultimaLectura;
  double get getIntervaloAlimentacion => _intervaloAlimentacion;
  Timestamp get getUltimaComida => _ultimaComida;

  set setId(String i)=>_id=i;
  set setTemperatura(double i)=>_temperatura=i;
  set setUltimaLectura(Timestamp  n)=>_ultimaLectura=n;
  set setIntervaloAlimentacion(double c)=>_intervaloAlimentacion=c;
  set setUltimaComida(Timestamp n)=>_ultimaComida=n;
  
  static Map<String, dynamic> toMapFromControl(TextEditingController temperaturaCont,
                                        TextEditingController ultimaLecturaCont,
                                        TextEditingController intervaloAlimentacionCont,
                                        TextEditingController ultimaComidaCont,
                                        TextEditingController codigoPostalCont,
                                        TextEditingController municipioCont,
                                        TextEditingController estadoCont,
                                        GeoPoint posicion){
        return {
          'temperatura':temperaturaCont.text,
          'ultimaLectura':ultimaLecturaCont.text,
          'intervaloAlimentacion':intervaloAlimentacionCont.text,
          'ultimaComida':ultimaComidaCont.text,
            };
  } 

  Modulo.map(String id,dynamic obj){
    this._id=id;
    this._temperatura=obj['temperatura'];
    this._ultimaLectura=obj['ultimaLectura'];
    this._intervaloAlimentacion=obj['intervaloAlimentacion'];
    this._ultimaComida=obj['ultimaComida'];
  }

    Modulo.fromSnapshot(DocumentSnapshot obj){
    
      
    this._id=obj.id;
    this._temperatura=obj.get('temperatura');
    this._ultimaLectura=obj.get('ultimaLectura');
    this._intervaloAlimentacion=obj.get('intervaloAlimentacion');
    this._ultimaComida=obj.get('ultimaComida');
  }


}