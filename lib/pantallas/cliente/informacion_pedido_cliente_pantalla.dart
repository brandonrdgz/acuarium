import 'dart:io';

import 'package:acuarium/componentes/banner_direccion.dart';
import 'package:acuarium/componentes/banner_pedido.dart';
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/pedido.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:acuarium/servicios/firebase/storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';


class InformacionPedidoClientePantalla extends StatefulWidget {
  
static const String id = 'InformacionPedidoClientePantalla';
  const InformacionPedidoClientePantalla({ Key? key }) : super(key: key);

  @override
  _InformacionPedidoClientePantallaState createState() => _InformacionPedidoClientePantallaState();
}

class _InformacionPedidoClientePantallaState extends State<InformacionPedidoClientePantalla> {
  Pedido _pedido=Pedido();
  final DateFormat _formatter = DateFormat('dd/MM/yyyy hh:mm a');


  Widget build(BuildContext context) {
    
    _pedido = ModalRoute.of(context)!.settings.arguments as Pedido;

    return  _dataFromStream();
  }

    _dataFromStream(){
    return StreamBuilder(
      stream: Firestore.datosPedido(pid: _pedido.getId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return _errorView('Error','Error al cargar los datos');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingView('Cargando','Cargando Datos');
        }

        if (!snapshot.data!.exists){
          return _errorView('Sin datos','No se encontraron los datos');
        }

        if (snapshot.data!.data()!.length==0) {
          return _errorView('Sin datos','No se encontraron los datos');
        }

        _pedido=Pedido.fromSnapshot(snapshot.data!);
        return _dataDisplay(_pedido);
  });
  }
  _loadingView(String titulo,String msgError){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(titulo),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: 
        InfoView(type: InfoView.LOADING_VIEW, context: context,)
            )
            );
  }
  _errorView(String titulo,String msgError){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(titulo),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child:InfoView(type: InfoView.ERROR_VIEW, context: context,msg: msgError,)
            )
            );
  }

  _dataDisplay(Pedido pedido){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text('Pedido'),
          backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              _dataView(), 
              EstadoPedido(pedido: _pedido,), 
          ],
        ),
      )
    );
  }
  


  _dataView(){
      return Tarjeta(
            color: Colors.white,
            contenido: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.infoCircle,
                    color: Colors.blueAccent
                  ),
                  title: Text('Datos del pedido'),
                  subtitle: Text('id: ${_pedido.getId}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.calendar,
                          color: Colors.blueAccent
                        ),
                        title: Text('Fecha del pedido'),
                        subtitle: Text('${_formatter.format(_pedido.getFecha.toDate())}'),
                      ),
                      DatosDireccion(idCliente: _pedido.getIdCliente, idDir:_pedido.getIdDireccion),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.shoppingBag,
                          color: Colors.blueAccent
                        ),
                        title: Text('Peces'),
                        subtitle: Text(_pedido.getTags.length>1?'${_pedido.getTags[0]} + ${_pedido.getTags.length-1}':'${_pedido.getTags[0]}'),
                        onTap: (){
                          _dialogoDetalles();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.moneyBill,
                          color: Colors.blueAccent
                        ),
                        title: Text('Total'),
                        subtitle: Text('\$${_pedido.getTotal}'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          );
  }

  _dialogoDetalles(){
                                    Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Detalles'),
                                          contenido: DatosPedido(idPedido: _pedido.getId,),
                                       acciones: [
                                          ]);
                          
  } 

}


class EstadoPedido extends StatefulWidget {
  final Pedido pedido;
  const EstadoPedido({ Key? key,required this.pedido }) : super(key: key);

  @override
  _EstadoPedidoState createState() => _EstadoPedidoState();
}

class _EstadoPedidoState extends State<EstadoPedido> {
  bool _hasImg =false;
  bool _hasImgLoaded=false;
  bool _hasImgChange=false;
  bool _showImg=false; 
  final Icon _iconoCamara = Icon(Icons.camera_enhance_rounded);
  final ImagePicker _imagePicker = ImagePicker();
  File? _file;
  bool _ban=true;

  @override
  Widget build(BuildContext context) {
    if(_ban){
    _hasImg=(widget.pedido.getComprobante['imgUrl'] as String).isNotEmpty;
    _hasImgLoaded=_hasImg;
    _ban=false;
    }
    return _estadoView();
  }

    _estadoView(){
      return Tarjeta(
            color: Colors.white,
            contenido: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.infoCircle,
                    color: Colors.yellow.shade800
                  ),
                  title: Text('Estado'),
                  subtitle: Text('${widget.pedido.getTextoEstado()}'),
                ),
                widget.pedido.getEstado==Pedido.CLAVE_CANCELADO||
                widget.pedido.getEstado==Pedido.CLAVE_ENTREGADO?
                SizedBox(height: 2,):
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Comprobante de pago'),
                        subtitle: Text(widget.pedido.getEstado==Pedido.CLAVE_PAGO_PENDIENTE?
                                      'No ha seleccionado ningún comprobante':
                                      widget.pedido.getEstado==Pedido.CLAVE_PAGO_RECHAZADO?
                                      '${widget.pedido.getRazon}':
                                      'Comprobante seleccionado'),
                      ),
                      Row(
                        children: <Widget>[
                          _hasImg?
                          TextButton(
                            child: Text(_showImg?'Ocultar':'Ver'),
                            onPressed:(){
                              setState(() {
                                _showImg=!_showImg;
                              });
                            }                            
                          ):SizedBox(),
                          widget.pedido.getEstado==Pedido.CLAVE_PAGO_PENDIENTE||
                          widget.pedido.getEstado==Pedido.CLAVE_PAGO_RECHAZADO?
                          TextButton(
                            child: Text('Seleccionar'),
                            onPressed: () {
                              _muestraModalInferiorSeleccionarImagen();
                            }
                          ):SizedBox(),
                        ],
                      ),
                      Container(
                          child:_getImg(),
                      ),
                    ],
                  ),
                ),
                widget.pedido.getEstado==Pedido.CLAVE_CANCELADO||
                widget.pedido.getEstado==Pedido.CLAVE_ENTREGADO?
                SizedBox(height: 2,):
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    widget.pedido.getEstado==Pedido.CLAVE_PAGO_PENDIENTE||
                    widget.pedido.getEstado==Pedido.CLAVE_PAGO_RECHAZADO?
                    IconButton(
                      icon: Icon(FontAwesomeIcons.save, color: Colors.blue),
                      tooltip: 'Guardar comprobante',
                      onPressed: () {
                        _saveDialog();
                      },
                    ):SizedBox(),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.ban, color: Colors.blueGrey),
                      tooltip: 'Cancelar pedido',
                      onPressed: () async{
                        var localAuth = LocalAuthentication();
                        try {
                        bool didAuthenticate =  await localAuth.authenticate(localizedReason: 'Por favor, identifiquese');
                          if(didAuthenticate){
                            _cancel();
                          }else{
                                Fluttertoast.showToast(
                                  msg: 'Vuelva a intentarlo',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blueGrey,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                        }

                        } on PlatformException catch (e) {
                        if (e.code == auth_error.notAvailable) {
                                            Fluttertoast.showToast(
                                            msg: '${e.message}',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.blueGrey,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                        }
                      }
                      }
                    )
                  ],
                )
              ],
            )
          );
  }

    _saveDialog(){
      Dialogo.dialogo(
        context,                                     
        titulo:Text('Atención'),
        contenido: Text('¿Guardar Comprobante?'),
        acciones: [
        IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                  onPressed: ()async{
                    Navigator.pop(context);
                    if(_hasImgLoaded){
                      _deleteImage();
                    }else{
                    _loadImage();
                    }
                    },),
        IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                  onPressed: ()=>{Navigator.pop(context)},),
        ]);
  }
  _deleteImage(){
          Dialogo.dialogoProgreso(context,
                          contenido: Text('Guardando Imagen'),
                          future: Storage.eliminaImagenComprobante( uid: widget.pedido.getId, name: widget.pedido.getComprobante['imgPath']), 
                          alTerminar: (resultado) async {
                            _loadImage();
                          }, 
                          enError: (resultado){
                            Fluttertoast.showToast(
                                msg: 'Error: $resultado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          },
                          );  

  }

    _loadImage(){
      Dialogo.dialogoProgreso(context,
                          contenido: Text('Guardando Imagen'),
                          future: Storage.guardaImagenComprobante( uid: widget.pedido.getId, img: _file!), 
                          alTerminar: (resultado) async {
                             TaskSnapshot ts =resultado as TaskSnapshot;
                            String imageUrl = await ts.ref.getDownloadURL();
                            String imagePath= ts.ref.name; 
                            var imgs = {
                              'imgUrl':imageUrl,
                              'imgPath':imagePath
                            };
                            _updateComp(imgs);
                          }, 
                          enError: (resultado){
                            Fluttertoast.showToast(
                                msg: 'Error: $resultado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          },
                          );  


  }
  

  _getImg(){
    if(!_showImg){
      return SizedBox(height: 1.0,);
    }else if(_hasImgLoaded&&!_hasImgChange){
      return  CachedNetworkImage(
                          imageUrl: widget.pedido.getComprobante['imgUrl'],
                          placeholder: (context, url) => new CircularProgressIndicator(),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          height: MediaQuery.of(context).size.width/2,
                        );
    }else if(_hasImgChange){
      return Image.file(_file!,height: MediaQuery.of(context).size.width/2,);


    }else{
      return Icon(FontAwesomeIcons.image,color: Colors.blueGrey,size:MediaQuery.of(context).size.width/2 ,);
    }

  }
    void _muestraModalInferiorSeleccionarImagen() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0)
        )
      ),
      builder: (context) {
        return Wrap(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Imagen')
              ],
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    _iconoCamara,
                    Text('Cámara')
                  ],
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                _escogerImagen(ImageSource.camera);
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.photoVideo),
                    Text('Galería')
                  ],
                )
              ),
              onTap: () async {
                Navigator.pop(context);
                _escogerImagen(ImageSource.gallery);
              },
            )
          ],
        );
      }
    );
  }

  void _escogerImagen(ImageSource source) async {
    XFile? imagenActual = await _imagePicker.pickImage(source: source);

    if (imagenActual != null) {
      setState(() {
       _file=File(imagenActual.path);
       _hasImg=true;
       _hasImgChange=true;
       _showImg=true;
      });
    }
  }


  _cancel(){
      Dialogo.dialogoProgreso(context,
                          contenido: Text('Cancelando Pedido'),
                          future: Firestore.actualizaEstadoPedido(pid: widget.pedido.getId, newState: Pedido.CLAVE_CANCELADO), 
                          alTerminar: (resultado){
                          Fluttertoast.showToast(
                                msg: 'Cancelado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }, 
                          enError: (resultado){
                            Fluttertoast.showToast(
                                msg: 'Error: $resultado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                          }, );


  }

  void _updateComp(Map<String, String> imgs) {
     Dialogo.dialogoProgreso(context,
                          contenido: Text('Actualizando Pedido'),
                          future: Firestore.actualizaComprobantePedido(pid: widget.pedido.getId, img:  imgs), 
                          alTerminar: (resultado) async {
                                Fluttertoast.showToast(
                                msg: 'Datos guardados',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }, 
                          enError: (resultado){
                            Fluttertoast.showToast(
                                msg: 'Error: $resultado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          },
                          );  
  }



}