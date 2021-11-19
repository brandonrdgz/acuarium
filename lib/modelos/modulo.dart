import 'package:cloud_firestore/cloud_firestore.dart';

class Modulo{
  String _id='';
  double _temperatura=0.0;
  Timestamp _ultimaLectura=Timestamp.now();
  double _luminocidad=0.0;

  Modulo();

  String get getId => _id;
  double get getTemperatura => _temperatura;
  Timestamp get getUltimaLectura =>_ultimaLectura;
  double get getLuminocidad => _luminocidad;

  set setId(String i)=>_id=i;
  set setTemperatura(double i)=>_temperatura=i;
  set setUltimaLectura(Timestamp  n)=>_ultimaLectura=n;
  set setLuminocidad(double c)=>_luminocidad=c;
  


  Modulo.map(String id,dynamic obj){
    this._id=id;
    this._temperatura=obj['temperatura'];
    this._ultimaLectura=obj['ultimaActualizacion'];
    this._luminocidad=obj['luminocidad'];
  }

    Modulo.fromSnapshot(DocumentSnapshot obj){
    
    this._id=obj.id;
    this._temperatura=obj.get('temperatura');
    this._ultimaLectura=obj.get('ultimaActualizacion');
    this._luminocidad=obj.get('luminocidad');
  }


}