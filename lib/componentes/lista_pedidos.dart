import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/pedido.dart';
import 'package:acuarium/pantallas/cliente/informacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/negocio/informacion_pedido_negocio_pantalla.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';

class PedidosLista extends StatefulWidget {
  final String idUsuario;
  final bool esNegocio;
  const PedidosLista({ Key? key ,required this.idUsuario,required this.esNegocio}) : super(key: key);

  @override
  _PedidosListaState createState() => _PedidosListaState();
}

class _PedidosListaState extends State<PedidosLista> {
  List<Pedido> _items=[];
   final DateFormat _formatter = DateFormat('dd/MM/yyyy hh:mm a');
  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
          _listFromStream()      
    );
  }

  _listBuilder(List<Pedido> items){
   return Column(
     children: [
      IconLabel(icon: Icon(FontAwesomeIcons.shoppingBag, color: Colors.blueAccent), text: ' Pedidos Recientes'),
     Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: 
              ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:5.0),
              itemBuilder: (context, position){
                return Tarjeta(
                  color:Colors.white,
                  contenido:_cardBody(items[position]),
              );
              }
              )
          ),
        ),]),
              ]);
}


  _cardBody(Pedido pedido){
   return Column(
                  children:<Widget> [
                    Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(pedido.getTags.length>1?'${pedido.getTags[0]} + ${pedido.getTags.length-1}':'${pedido.getTags[0]}',                      
                          style:TextStyle(color: Colors.black,fontSize: 21.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text('Id: ${pedido.getId}',
                          textAlign: TextAlign.justify,
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          Text('Número de peces: ${pedido.getProductos}',
                          textAlign: TextAlign.justify,
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          Text('Estado : ${pedido.getTextoEstado()}',
                          textAlign: TextAlign.justify,
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          Text('Fecha : ${_formatter.format(pedido.getFecha.toDate())}',
                          textAlign: TextAlign.justify,
                          style:TextStyle(color: Colors.black,fontSize: 12.0)),
                          ],),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 17.0,
                              child: Icon(FontAwesomeIcons.shoppingBag, color: Colors.white,),
                              ),
                          ],),
                          onTap: () {
                            if(widget.esNegocio){
                                  Navigator.pushNamed(context, InformacionPedidoNegocioPantalla.id,arguments:pedido);
                            }else{
                                  Navigator.pushNamed(context, InformacionPedidoClientePantalla.id,arguments:pedido);
                            }
                           
                          },
                        )
                        ),
                    ],)
                  ],
             );


 }

  _view(int i){
    switch(i){
      case 1:
        return Column(
            children: [
              IconLabel(icon: Icon(FontAwesomeIcons.fish, color: Colors.blueAccent), text: ' Pedidos'),
              InfoView(type: InfoView.ERROR_VIEW, context: context,msg: 'Ocurrio un error'),
            ]);
      case 2:
        return Column(
            children: [
                IconLabel(icon: Icon(FontAwesomeIcons.fish, color: Colors.blueAccent), text: ' Pedidos'),
                InfoView(type: InfoView.LOADING_VIEW, context: context,),
            ]);
      case 3:
        return Column(
            children: [
                IconLabel(icon: Icon(FontAwesomeIcons.fish, color: Colors.blueAccent), text: ' Pedidos'),
                InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'Sin datos'),
            ]);
    }

  }


  _listFromStream(){
  return  StreamBuilder(
  stream: Firestore.listaPedidos(uid: widget.idUsuario,esNegocio: widget.esNegocio),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _view(1);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _view(2);
        }

        if (snapshot.data!.docs.isEmpty) {
          return _view(3);
        }

        _items.clear();
        snapshot.data!.docs.forEach((element) {
          _items.add(Pedido.fromSnapshot(element));
        });
        return _listBuilder(_items);
  });

}
}