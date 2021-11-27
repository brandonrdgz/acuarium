import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/rounded_icon_text_form_field.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/pedido.dart';
import 'package:acuarium/pantallas/negocio/informacion_pedido_negocio_pantalla.dart';
import 'package:acuarium/pantallas/negocio/menu_negocio_drawer.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListadoPedidosNegocioPantalla extends StatefulWidget {
  static const String id = 'ListadoPedidosNegocio';
  const ListadoPedidosNegocioPantalla({ Key? key }) : super(key: key);

  @override
  _ListadoPedidosNegocioPantallaState createState() => _ListadoPedidosNegocioPantallaState();
}

class _ListadoPedidosNegocioPantallaState extends State<ListadoPedidosNegocioPantalla> {

 TextEditingController _searchController= new TextEditingController();
  List<Pedido> _items=[];
  List<Pedido> _filterItems=[];
  static final String _title ='Pedidos';
  final DateFormat _formatter = DateFormat('dd/MM/yyyy hh:mm a');
  bool _isSearching=false;

      @override
  void initState() {
      super.initState();
  }
@override
  void dispose(){
    super.dispose();
    _searchController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.blueAccent,
      ),
      body: Column(children: [
            _searchField(),
            Divider(),
            Flexible(
              child:_isSearching?_listFromFilter():_listFromStream()            
            )
            ],
          ),
    ));
  }

  _searchField(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: 
                    RoundedIconTextFormField(
                      validator: (val) => val!.isEmpty ?' vacio':null,
                      labelText: 'Búsqueda',
                      controller: _searchController,
                      prefixIcon:Icons.search,
                      keyboardType: TextInputType.text,
                      onChanged: (string) {
                          setState(() {
                            _searchController.text.isNotEmpty?_isSearching=true:_isSearching=false;
                            if(_isSearching){
                              _filterItems.clear();
                              String b=_searchController.text.toLowerCase();
                              if(b==Pedido.CANCELADO.toLowerCase()||
                                b==Pedido.ENTREGADO.toLowerCase()||
                                b==Pedido.PAGO_RECHAZADO.toLowerCase()||
                                b==Pedido.EN_CAMINO.toLowerCase()||
                                b==Pedido.COMPROBANTE_SUBIDO.toLowerCase()||
                                b==Pedido.PAGO_PENDIENTE.toLowerCase()){
                                _items.forEach((element) {
                                if(element.tieneEstado(b)){
                                    _filterItems.add(element);
                                }
                                });
                                }else{
                              _items.forEach((element) {
                                for(int i=0;i<element.getTags.length;i++){
                                  if(element.getTags[i].startsWith(_searchController.text)){
                                    _filterItems.add(element);
                                    break;
                                  }
                                }                              
                               }
                               );
                          }
                        }});
                      }
                    ),
                    )
                  ]);               
}
  _listFromFilter(){
        if (_filterItems.length==0) {
          return InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'Sin resultados');
        }else{
          return _listBuilder(_filterItems);
        }
        
  }

  _listFromStream(){
  return  StreamBuilder(
  stream: Firestore.listaPedidosNegocio(uid: Auth.getUserId()!),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return InfoView(type: InfoView.ERROR_VIEW, context: context,msg: 'Ocurrio un error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return InfoView(type: InfoView.LOADING_VIEW, context: context,);
        }

        if (snapshot.data!.docs.isEmpty) {
          return InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'Sin pedidos');
        }

        _items.clear();
        snapshot.data!.docs.forEach((element) {
          _items.add(Pedido.fromSnapshot(element));
        });
        
        return _listBuilder(_items);
  });

}

  _listBuilder(List<Pedido> items){
   return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:12.0),
              itemBuilder: (context, position){
                return 
                 Tarjeta(contenido: _cardBody(items[position]),color:Colors.white);
              }
              );
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
                            Navigator.pushNamed(context, InformacionPedidoNegocioPantalla.id,arguments:pedido);
                          },
                        )
                        ),
                    ],)
                  ],
             );


 }

}