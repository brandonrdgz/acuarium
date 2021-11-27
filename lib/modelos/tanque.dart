import 'package:cached_network_image/cached_network_image.dart';
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
  double _temperaturaMax=0.0;
  double _temperaturaMin=0.0;
  String _fechaMontaje='';
  double _luminocidadMin=0.0;
  double _luminocidadMax=0.0;
  List<dynamic> _galeria=[];


  Tanque();

  String get getId => _id;
  String get getidCliente => _idCliente;
  String get getNombre =>_nombre;
  String get getIdModulo => _idModulo;
  double get getLitros => _litros;
  double get getAlto => _alto;
  double get getAncho => _ancho;
  double get getProfundo => _profundo;
  double get getTemperaturaMax => _temperaturaMax;
  double get getTemperaturaMin => _temperaturaMin;
  String get getFechaMontaje => _fechaMontaje;
  double get getLuminocidadMin => _luminocidadMin;
  double get getLuminocidadMax => _luminocidadMax;
  List<dynamic> get getGaleria => _galeria;

  set setId(String id) => _id=id;
  set setIdCliente(String id) => _idCliente=id;
  set setNombre(String n) => _nombre=n;
  set setIdModulo(String id) => _idModulo=id;
  set setLitros(double l) => _litros=l;
  set setAlto(double a) => _alto=a;
  set setAncho(double a) => _ancho=a;
  set setProfundo(double p) => _profundo=p;
  set setLuminocidadMin(double p) => _luminocidadMin=p;
  set setLuminocidadMax(double p) => _luminocidadMax=p;
  set setTemperaturaMax(double p) => _temperaturaMax=p;
  set setTemperaturaMin(double p) => _temperaturaMin=p;
  set setFechaMontaje(String f) => _fechaMontaje=f;
  set setGaleria(List<dynamic> l) => _galeria=l;



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
  
  
  static Map<String, dynamic> toMapFromControl(
                                        String idCliente,
                                        String idModulo,
                                        TextEditingController nombreCont,
                                        TextEditingController litrosCont,
                                        TextEditingController altoCont,
                                        TextEditingController anchoCont,
                                        TextEditingController profundoCont,
                                        TextEditingController temperaturaMaxCont,
                                        TextEditingController temperaturaMinCont,
                                        TextEditingController fechaMontajeCont,
                                        TextEditingController luminocidadMinCont,
                                        TextEditingController luminocidadMaxCont,
                                        List<dynamic> imgs){
        return {
          'idCliente':idCliente,
          'idModulo':idModulo,
          'nombre':nombreCont.text,
          'litros':litrosCont.text,
          'alto':altoCont.text,
          'ancho':anchoCont.text,
          'profundo':profundoCont.text,
          'temperaturaMax':temperaturaMaxCont.text,
          'temperaturaMin':temperaturaMinCont.text,
          'fechaMontaje':fechaMontajeCont.text,
          'luminocidadMin':luminocidadMinCont.text,
          'luminocidadMax':luminocidadMaxCont.text,
          'imagenes':imgs
          
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
    this._temperaturaMax=obj['temperaturaMax'];
    this._temperaturaMin=obj['temperaturaMin'];
    this._fechaMontaje=obj['fechaMontaje'];
    this._galeria=obj['imagenes'];
    this._luminocidadMax=obj['luminocidadMax'];
    this._luminocidadMin=obj['luminocidadMin'];
  }

    Tanque.fromSnapshot(DocumentSnapshot obj){      
    this._id=obj.id;    
    this._idCliente=obj.get('idCliente');
    this._nombre=obj.get('nombre');
    this._idModulo=obj.get('idModulo');
    this._litros=double.parse(obj.get('litros'));
    this._alto=double.parse(obj.get('alto'));
    this._ancho=double.parse(obj.get('ancho'));
    this._temperaturaMax=double.parse(obj.get('temperaturaMax'));
    this._temperaturaMin=double.parse(obj.get('temperaturaMin'));
    this._profundo=double.parse(obj.get('profundo'));
    this._fechaMontaje=obj.get('fechaMontaje');
    this._galeria=obj.get('imagenes');
    this._luminocidadMin=double.parse(obj.get('luminocidadMin'));
    this._luminocidadMax=double.parse(obj.get('luminocidadMax'));

  }


}

