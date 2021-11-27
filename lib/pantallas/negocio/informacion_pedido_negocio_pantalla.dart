import 'package:acuarium/componentes/banner_direccion.dart';
import 'package:acuarium/componentes/banner_pedido.dart';
import 'package:acuarium/componentes/banner_usuario.dart';
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelo/data_table_data_source.dart';
import 'package:acuarium/modelo/fila.dart';
import 'package:acuarium/modelos/pedido.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class InformacionPedidoNegocioPantalla extends StatefulWidget {
  
static const String id = 'InformacionPedidoNegocioPantalla';
  const InformacionPedidoNegocioPantalla({ Key? key }) : super(key: key);

  @override
  _InformacionPedidoNegocioPantallaState createState() => _InformacionPedidoNegocioPantallaState();
}

class _InformacionPedidoNegocioPantallaState extends State<InformacionPedidoNegocioPantalla> {
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
              EstadoPedidoNegocio(pedido: _pedido,), 
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
                      DatosCliente(uid: _pedido.getIdCliente,),
                      DatosDireccion(idCliente: _pedido.getIdCliente,idDir:_pedido.getIdDireccion),
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


class EstadoPedidoNegocio extends StatefulWidget {
  final Pedido pedido;
  const EstadoPedidoNegocio({ Key? key,required this.pedido }) : super(key: key);

  @override
  _EstadoPedidoNegocioState createState() => _EstadoPedidoNegocioState();
}

class _EstadoPedidoNegocioState extends State<EstadoPedidoNegocio> {
  bool _hasImgLoaded=false;
  bool _showImg=false; 
  TextEditingController tc= TextEditingController();
  bool _ban=true;

  @override
  Widget build(BuildContext context) {
    if(_ban){
    _hasImgLoaded=(widget.pedido.getComprobante['imgUrl'] as String).isNotEmpty;
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
                                      'No se ha subido ningún comprobante':
                                      widget.pedido.getEstado==Pedido.CLAVE_PAGO_RECHAZADO?
                                      '${widget.pedido.getRazon}':
                                      'Comprobante subido'),
                      ),
                      Row(
                        children: <Widget>[
                          widget.pedido.getEstado!=Pedido.CLAVE_PAGO_PENDIENTE&&_hasImgLoaded?
                          TextButton(
                            child: Text(_showImg?'Ocultar':'Ver'),
                            onPressed:(){
                              setState(() {
                                _showImg=!_showImg;
                              });
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
                widget.pedido.getEstado==Pedido.CLAVE_COMPROBANTE_SUBIDO||
                widget.pedido.getEstado==Pedido.CLAVE_EN_CAMINO?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: 
                  widget.pedido.getEstado==Pedido.CLAVE_COMPROBANTE_SUBIDO?
                  <Widget>[                    
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.check, color: Colors.blue),
                      tooltip: 'Aceptar comprobante',
                      onPressed: () {
                        _aceptarDialog();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.times, color: Colors.blueGrey),
                      tooltip: 'Rechazar comprobante',
                      onPressed: () {
                        _rechazarDialog();
                      },
                    ),
                    ]:
                    widget.pedido.getEstado==Pedido.CLAVE_EN_CAMINO?
                    <Widget>[
                      IconButton(
                      icon: Icon(
                        FontAwesomeIcons.truck, color: Colors.blueGrey),
                      tooltip: 'Marcar como entregado',
                      onPressed: () {
                        _entregarDialog();
                      },
                    ),
                    ]:
                    <Widget>[],
                ):
                SizedBox(height: 2,),
              ],
            )
          );
  }

    _aceptarDialog(){
      Dialogo.dialogo(
        context,                                     
        titulo:Text('Atención'),
        contenido: Text('¿Aceptar Comprobante?'),
        acciones: [
        IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                  onPressed: ()async{
                    Navigator.pop(context);
                      _actualiza(Pedido.CLAVE_EN_CAMINO);
                    },),
        IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                  onPressed: ()=>{Navigator.pop(context)},),
        ]);
  }

      _rechazarDialog(){
      tc.text='';
      Dialogo.dialogo(
        context,                                     
        titulo:Text('Atención'),
        contenido: SizedBox(height: MediaQuery.of(context).size.height/4.5,
        child: Column(
          children: [
            Text('¿Rechazar Comprobante?'),
            TextField(
                    controller: tc,
                    maxLines: 5,
                    decoration: InputDecoration(
                labelText: 'Razón',
                errorMaxLines: 10,
                prefixIcon: Icon(FontAwesomeIcons.comment),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  borderSide: BorderSide(
                    color: Colors.red.shade200
                  )
                )
              ),
            )

          ],
        )
        ),
        acciones: [
        IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                  onPressed: ()async{
                    if(tc.text.isEmpty){
                          Fluttertoast.showToast(
                                msg: 'Ingrese la razón',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                    }else{                      
                    Navigator.pop(context);
                    _actualiza(Pedido.CLAVE_PAGO_RECHAZADO);
                    }

                    },),
        IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                  onPressed: ()=>{Navigator.pop(context)},),
        ]);
  }

        _entregarDialog(){
      Dialogo.dialogo(
        context,                                     
        titulo:Text('Atención'),
        contenido: Text('¿Marcar pedido como entregado?'),
        acciones: [
        IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                  onPressed: ()async{
                    Navigator.pop(context);
                      _actualiza(Pedido.CLAVE_ENTREGADO);
                    },),
        IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                  onPressed: ()=>{Navigator.pop(context)},),
        ]);
  }

  _getImg(){
    if(!_showImg){
      return SizedBox(height: 1.0,);
    }else if(_hasImgLoaded){
      return  CachedNetworkImage(
                          imageUrl: widget.pedido.getComprobante['imgUrl'],
                          placeholder: (context, url) => new CircularProgressIndicator(),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          height: MediaQuery.of(context).size.width/2,
                        );
    }else{
      return Icon(FontAwesomeIcons.image,color: Colors.blueGrey,size:MediaQuery.of(context).size.width/2 ,);
    }

  }


  _actualiza(int estado){
      Dialogo.dialogoProgreso(context,
                          contenido: Text('Actualizando Pedido'),
                          future: Firestore.actualizaEstadoPedido(pid: widget.pedido.getId, newState: estado,razon: tc.text), 
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




}