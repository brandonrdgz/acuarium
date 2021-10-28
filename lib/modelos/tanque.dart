import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tanque{
  String _id='';
  String _idCliente='';
  String _idModulo='';
  String _nombre='';
  double _litros=0.0;
  double _alto=0.0;
  double _ancho=0.0;
  double _profundo=0.0;
  double _temperatura=0.0;
  String _fechaMontaje='';
  List<String> _galeria=[];


  Tanque();

  String get getId => _id;
  String get getidCliente => _idCliente;
  String get getNombre =>_nombre;
  String get getIdModulo => _idModulo;
  double get getLitros => _litros;
  double get getAlto => _alto;
  double get getAncho => _ancho;
  double get getProfundo => _profundo;
  double get getTemperatura => _temperatura;
  String get getFechaMontaje => _fechaMontaje;
  List<String> get getGaleria => _galeria;

  set setId(String id) => _id=id;
  set setIdCliente(String id) => _idCliente=id;
  set setNombre(String n) => _nombre=n;
  set setIdModulo(String id) => _idModulo=id;
  set setLitros(double l) => _litros=l;
  set setAlto(double a) => _alto=a;
  set setAncho(double a) => _ancho=a;
  set setProfundo(double p) => _profundo=p;
  set setTemperatura(double p) => _temperatura=p;
  set setFechaMontaje(String f) => _fechaMontaje=f;
  set setGaleria(List<String> l) => _galeria=l;



  List<Image> getGaleriaImgs() {
    List<Image> images=[];
    if(_galeria.length>0){
      _galeria.forEach((element) { 
      //images.add(Image.network(element));
      images.add(Image(image: AssetImage(element)));
    });
    }
    return images;
    }
  
  
  static Map<String, dynamic> toMapFromControl(String idCliente,
                                        String idModulo,
                                        TextEditingController nombreCont,
                                        TextEditingController litrosCont,
                                        TextEditingController altoCont,
                                        TextEditingController anchoCont,
                                        TextEditingController profundoCont,
                                        TextEditingController temperaturaCont,
                                        TextEditingController fechaMontajeCont){
        return {
          'idCliente':idCliente,
          'idModulo':idModulo,
          'nombre':nombreCont.text,
          'litros':litrosCont.text,
          'alto':altoCont.text,
          'ancho':anchoCont.text,
          'profundo':profundoCont.text,
          'temperatura':temperaturaCont.text,
          'fechaMontaje':fechaMontajeCont.text
            };
  } 

  Tanque.map(String id,dynamic obj){
    this._id=id;
    this._idCliente=obj['idCliente'];
    this._idModulo=obj['idModulo'];
    this._nombre=obj['nombre'];
    this._litros=obj['litros'];
    this._alto=obj['alto'];
    this._ancho=obj['ancho'];
    this._profundo=obj['profundo'];
    this._temperatura=obj['temperatura'];
    this._fechaMontaje=obj['fechaMontaje'];
    this._galeria=obj['galeria'];
  }

    Tanque.fromSnapshot(DocumentSnapshot obj){      
    this._id=obj.id;    
    this._idCliente=obj.get('idCliente');
    this._nombre=obj.get('nombre');
    this._idModulo=obj.get('idModulo');
    this._litros=obj.get('litros');
    this._alto=obj.get('alto');
    this._ancho=obj.get('ancho');
    this._temperatura=obj.get('temperatura');
    this._profundo=obj.get('profundo');
    this._fechaMontaje=obj.get('fechaMontaje');
    this._galeria=obj.get('galeria');

  }


}

