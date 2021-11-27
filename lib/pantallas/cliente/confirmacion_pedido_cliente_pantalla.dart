import 'package:acuarium/componentes/control_direcciones.dart';
import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelo/data_table_data_source.dart';
import 'package:acuarium/modelo/fila.dart';
import 'package:acuarium/modelos/direccion.dart';
import 'package:acuarium/modelos/item_carrito.dart';
import 'package:acuarium/modelos/pedido.dart';
import 'package:acuarium/pantallas/cliente/informacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_pedidos_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
import 'package:acuarium/servicios/firebase/auth.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;


class ConfirmacionPedidoClientePantalla extends StatefulWidget {
  static const String id = 'ConfirmacionPedidoClientePantalla';
  const ConfirmacionPedidoClientePantalla({ Key? key }) : super(key: key);

  @override
  _ConfirmacionPedidoClientePantallaState createState() => _ConfirmacionPedidoClientePantallaState();
}

class _ConfirmacionPedidoClientePantallaState extends State<ConfirmacionPedidoClientePantalla> {
  final List<ItemCarrito> _items=[];
  final Direccion _direccion=Direccion();
  Pedido _p= Pedido();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirmación de pedido'),),
      body: 
      SingleChildScrollView(
        child: Column(
        children: <Widget>[
            _pedidoFromStream(),
            SeleccionDireccion(dir: _direccion,), 
          
      ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.check),
        onPressed: () async {
          if(_direccion.getId.isNotEmpty){
          var localAuth = LocalAuthentication();
          try {
          bool didAuthenticate =  await localAuth.authenticate(localizedReason: 'Por favor, identifiquese');
          if(didAuthenticate){
            List<ItemCarrito> i= _items;
            _guardarPedido(i);
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
          }else{
                            Fluttertoast.showToast(
                                msg: 'Seleccione una dirección de entrega',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
            

          }
          },
      )
    );
  }


  _pedidoFromStream(){
    
    return StreamBuilder(
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
            
            return _tableBuilder(_items);
          }
          );

  }

  _tableBuilder(List<ItemCarrito> items) {
    final List<Fila> filas = [];
    double total=0;
    items.forEach((element) { 
      
    Fila fila=Fila(celdas: <String>['${element.getImgUrl}','${element.getNombre}', '${element.getCantidad}', '\$${element.getPrecio}','\$${element.getPrecio*element.getCantidad}']);
    filas.add(fila);
    total=total+(element.getPrecio*element.getCantidad);
    });

    return Tarjeta(
      
            color: Colors.white,
            contenido:           
            Column(
            children:[
            PaginatedDataTable(
            header: Text('Peces'),
            rowsPerPage: 5,
            columnSpacing: 5,
            columns: <DataColumn>[
              DataColumn(label: Text('Imagen')),
              DataColumn(label: Text('Especie')),
              DataColumn(label: Text('Número')),
              DataColumn(label: Text('Precio')),
              DataColumn(label: Text('Subtotal')),
            ],            
            source: DataTableDataSourceP(context: context, filas: filas,imgWidth: 100)
            ),
            Tarjeta(
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
            ]
            )
    );

  }

  _guardarPedido(List<ItemCarrito> items){
    double total=0.0;
    List<String> nid=[];
    List<String> tags=[];
    items.forEach((element) {
      total=total+(element.getCantidad*element.getPrecio);
      nid.add(element.getIdNegocio);
      tags.add(element.getNombre);
     });
  Map<String,dynamic> data=Pedido.toMapFromControl(Auth.getUserId()!, nid,tags, items.length, total,_direccion.getId);
  var res = Firestore.crearPedido(data: data);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Guardando Pedido'),
                          future: res, 
                          alTerminar: (resultado){
                            DocumentReference<Map<String,dynamic>> r = resultado as DocumentReference<Map<String,dynamic>>;
                            int i=0;
                            _p.setId(r.id);
                            _guardaItemsPedido(i,r.id,items);
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

  _guardaItemsPedido(int index,String id,List<ItemCarrito> item){
  if(index<item.length){
  Map<String,dynamic> data = ItemPedido.MapfromItemCarrito(item.elementAt(index));
  var res = Firestore.agregaItemPedido(id: id, data: data);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Guardando Pedido'),
                          future: res, 
                          alTerminar: (resultado){ 
                             int i=index+1;
                            _guardaItemsPedido(i,id,item);
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
  }else{
    int i=0;
    _limpiaCarrito(i,item);
  }
  

  }

  _limpiaCarrito(int index,List<ItemCarrito> items){
  if(index<items.length){
  var res = Firestore.eliminarCarrito(uid: Auth.getUserId()!, did: items.elementAt(index).getId);
  Dialogo.dialogoProgreso(context,
                          contenido: Text('Guardando Pedido'),
                          future: res, 
                          alTerminar: (resultado){
                            int i=index+1;
                            _limpiaCarrito(i,items);
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
    }else{
              Navigator.popUntil(context, ModalRoute.withName(PaginaPrincipalClientePantalla.id));
              Navigator.pushNamed(context, ListadoPedidosClientePantalla.id);
              Navigator.pushNamed(context, InformacionPedidoClientePantalla.id,arguments:_p);

      
    }
  

  }


}


