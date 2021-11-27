import 'package:cached_network_image/cached_network_image.dart';
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

class PezVenta{
  String _id='';
  String _idNegocio='';
  String _nombre='';
  int _numero=0;
  double _precio=0.0;
  String _ciudados='';
  List<dynamic> _galeria=[];
  String _modelo='';
  bool _disponible=false;



  PezVenta();

  String get getId => _id;
  String get getModelo => _modelo;
  String get getIdNegocio => _idNegocio;
  double get getPrecio => _precio;
  String get getNombre =>_nombre;
  int get getNumero => _numero;
  String get getCuidados => _ciudados;
  List<dynamic> get getImagen => _galeria;
  bool get getDisponible => _disponible;
  
  set setId(String d)=>_id=d;
  set setIdNegocio(String d)=>_idNegocio=d;
  set setModelo(String m)=>_modelo=m;
  set setPrecio(double d)=>_precio=d;
  set setNombre(String n)=>_nombre=n;
  set setNumero(int n)=>_numero=n;
  set setCuidados(String c)=>_ciudados=c;
  set setImagen(List<dynamic> u)=>_galeria=u;
  set setDisponible(bool d)=>_disponible=d;

    Widget getCardImgs() {
    if(_galeria.length>0){
      var entry = _galeria[0];
      return CachedNetworkImage(
        imageUrl: entry['imgUrl']!,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ); 
    }else{
      return Image(image: AssetImage('images/acuarium.png'));
    }
    }

      List<Widget> getGaleriaImgs() {
    List<Widget> images=[];
    if(_galeria.length>0){
      _galeria.forEach((element) { 
      images.add(CachedNetworkImage(
        imageUrl: element['imgUrl']!,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ));
      
    });
    }else{
      images.add(Image(image: AssetImage('images/acuarium.png')));
    }
    return images;
    }
  
  static Map<String, dynamic> toMapFromControl(
                                        String uid,
                                        TextEditingController nombreCont,
                                        TextEditingController precioCont,
                                        TextEditingController numeroCont,
                                        TextEditingController modeloCont,
                                        TextEditingController cuidadosCont,
                                        bool disponible,
                                        List<dynamic> urlImg){
        return {
          'idNegocio':uid,
          'nombre':nombreCont.text,
          'numero':numeroCont.text,
          'precio':precioCont.text,
          'modelo':modeloCont.text,
          'cuidados':cuidadosCont.text,
          'imagen':urlImg,
          'disponible':disponible
          };
  } 

  PezVenta.map(String id,dynamic obj){
    this._id=id;
    this._idNegocio=obj['idNegocio'];
    this._precio=obj['precio'];
    this._nombre=obj['nombre'];
    this._numero=obj['numero'];
    this._ciudados=obj['cuidados'];
    this._modelo=obj['modelo'];
    this._galeria=obj['imagen'];
    this._disponible=obj['disponible'];
  }

    PezVenta.fromSnapshot(DocumentSnapshot obj){      
    this._id=obj.id;    
    this._idNegocio=obj.get('idNegocio');
    this._precio=double.parse(obj.get('precio'));
    this._nombre=obj.get('nombre');
    this._numero= int.parse(obj.get('numero'));
    this._ciudados=obj.get('cuidados');
    this._modelo=obj.get('modelo');
    this._galeria=obj.get('imagen');
    this._disponible=obj.get('disponible');

  }


}

