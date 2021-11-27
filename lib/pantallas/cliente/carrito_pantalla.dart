
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/etiquetas.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelos/item_carrito.dart';
import 'package:acuarium/pantallas/cliente/confirmacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CarritoPantalla extends StatefulWidget {
  static const String id = 'CarritoPantalla';
  const CarritoPantalla({ Key? key }) : super(key: key);

  @override
  _CarritoPantallaState createState() => _CarritoPantallaState();
}

class _CarritoPantallaState extends State<CarritoPantalla> {
  TextEditingController _searchController= new TextEditingController();
  List<ItemCarrito> _items=[];
  static final String _title ='Carrito';
  final DateFormat _formatter = DateFormat('dd/MM/yyyy hh:mm a');

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
      body: _listFromStream(),
        floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.moneyCheckAlt),
        tooltip: 'Proceder al pago',
        onPressed: () {
          Navigator.pushNamed(
            context,
            ConfirmacionPedidoClientePantalla.id
          );
        }
      ),
    ));
  }



  _listFromStream(){
  return  StreamBuilder(
  stream: Firestore.datosCarrito(uid: Auth.getUserId()!),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return InfoView(type: InfoView.ERROR_VIEW, context: context,msg: 'Ocurrio un error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return InfoView(type: InfoView.LOADING_VIEW, context: context,);
        }

        if (snapshot.data!.docs.isEmpty) {
          return InfoView(type: InfoView.INFO_VIEW, context: context,msg: 'El carrito esta vacío');
        }

        _items.clear();
        snapshot.data!.docs.forEach((element) {
          _items.add(ItemCarrito.fromSnapshot(element));
        });
        
        return _listBuilder(_items);
  });

}

  _listBuilder(List<ItemCarrito> items){
    double total=0;
    items.forEach((element) { 
      total=total+(element.getPrecio*element.getCantidad);
    });
   return Column(children:[
              Flexible(
                flex: 9,
              child:Container(
              child:ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top:12.0),
              itemBuilder: (context, position){
                return 
                 Tarjeta(contenido: _cardBody(items[position]),color:Colors.white);
              }
              )
              )
              ),
              Flexible(
                flex: 1,
                child: Container(
                    child: Tarjeta(
                    color:Colors.blueAccent,
                    contenido: Column(children: [
                      SizedBox(height: 5,),
                      Text(
                                  'Total: \$$total',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                      SizedBox(height: 5,),
                    ])
                    ),
                ))              
              ]
              );
}


  _cardBody(ItemCarrito item){
   return Column(
                    children: <Widget>[
                      ListTile(
                        leading:  CachedNetworkImage(
                              imageUrl: item.getImgUrl,
                              placeholder: (context, url) => new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                            ),
                        title: Text('${item.getNombre}'),
                        subtitle: Text('Cantidad: ${item.getCantidad}\nPrecio/u:\$${item.getPrecio}'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.info, color: Colors.blue),
                            onPressed: () {
                              _see(context,item);
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.minusCircle, color: Colors.blue),
                            onPressed: () {
                                      Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('Atención'),
                                          contenido: Text('¿Quitar ${item.getNombre} del carrito?'),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: (){
                                                        Navigator.pop(context);
                                                        _quit(context,item);
                                                        },),
                                            IconButton(icon: Icon(FontAwesomeIcons.ban,color: Colors.blueGrey),
                                                        onPressed: ()=>{Navigator.pop(context)},),
                                          ]);

                            },
                          )
                        ]
                      )
                    ],
                  ); 


 }

 _infoContent(ItemCarrito item){
   return SingleChildScrollView(
     child:
                Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: item.getImgUrl,
                                                placeholder: (context, url) => new CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                              ),
                                              Divider(thickness: 2.0,),
                                              IconLabel(icon:Icon(FontAwesomeIcons.fish, color: Colors.blueAccent),text: ' Descripción'),                          
                                              Row(
                                                children: [
                                                  Expanded(child: 
                                                      Text("${item.getDescripcion}",
                                                            style: TextStyle( fontWeight: FontWeight.normal, fontSize:16.0,),
                                                            textAlign: TextAlign.justify, 
                                                            )
                                                  ,),
                                                ],
                                              ),
                                              Divider(thickness: 2.0,),
                                              IconLabel(icon:Icon(FontAwesomeIcons.calendar, color: Colors.blueAccent),text: ' Fecha'),                          
                                              Row(
                                                children: [
                                                  Expanded(child: 
                                                      Text("${_formatter.format(item.getFecha.toDate())}",
                                                            style: TextStyle( fontWeight: FontWeight.normal, fontSize:16.0,),
                                                            textAlign: TextAlign.right, 
                                                            )
                                                  ,),
                                                ],
                                              ),
                                              Divider(thickness: 2.0,),
                                              IconLabel(icon:Icon(FontAwesomeIcons.moneyBill, color: Colors.blueAccent),text: '  Precio por unidad'),                          
                                              Row(
                                                children: [
                                                  Expanded(child: 
                                                      Text("\$${item.getPrecio}",
                                                            style: TextStyle( fontWeight: FontWeight.normal, fontSize:16.0,),
                                                            textAlign: TextAlign.right, 
                                                            )
                                                  ,),
                                                ],
                                              ),
                                              IconLabel(icon:Icon(FontAwesomeIcons.hashtag,color: Colors.blueAccent),text: '  Cantidad'),                          
                                              Row(
                                                children: [
                                                  Expanded(child: 
                                                      Text("${item.getCantidad} u",
                                                            style: TextStyle( fontWeight: FontWeight.normal, fontSize:16.0,),
                                                            textAlign: TextAlign.right, 
                                                            )
                                                  ,),
                                                ],
                                              ),
                                              Divider(thickness: 2.0,),
                                              IconLabel(icon:Icon(FontAwesomeIcons.moneyCheck, color: Colors.blueAccent),text: '  SubTotal'),                          
                                              Row(
                                                children: [
                                                  Expanded(child: 
                                                      Text("\$${item.getPrecio*item.getCantidad}",
                                                            style: TextStyle( fontWeight: FontWeight.normal, fontSize:16.0,),
                                                            textAlign: TextAlign.right, 
                                                            )
                                                  ,),
                                                ],
                                              ),
                                            ],
                                            )
                                          );
 }


  _quit(BuildContext context, ItemCarrito p) {
      var res = Firestore.eliminarCarrito(did:p.getId, uid:Auth.getUserId()! );
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Quitando ${p.getNombre}'),
                          future: res, 
                          alTerminar: (resultado){    
                                Fluttertoast.showToast(
                                msg: 'Listo',
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

                          }, );
  
  }
  _see(BuildContext context, ItemCarrito item) {
                                      Dialogo.dialogo(
                                          context,                                     
                                          titulo:Text('${item.getNombre}'),
                                          contenido: _infoContent(item),
                                          acciones: [
                                            IconButton(icon: Icon(FontAwesomeIcons.check, color: Colors.blueAccent,),
                                                        onPressed: ()=>{
                                                          Navigator.pop(context)
                                                        },),
                                          ]);
  }


}