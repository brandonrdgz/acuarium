import 'package:acuarium/componentes/info_views.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelo/data_table_data_source.dart';
import 'package:acuarium/modelo/fila.dart';
import 'package:acuarium/modelos/pedido.dart';
import 'package:acuarium/servicios/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatosPedido extends StatefulWidget {
  final String idPedido;
  const DatosPedido({ Key? key, required this.idPedido}) : super(key: key);

  @override
  _DatosPedidoState createState() => _DatosPedidoState();
}

class _DatosPedidoState extends State<DatosPedido> {
  final List<ItemPedido> _items=[];
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height/2.2,
    child: _pedidoFromStream(),);
  }

    _pedidoFromStream(){    
    return StreamBuilder(
      stream: Firestore.listaItemsPedido(pid:widget.idPedido),
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
              _items.add(ItemPedido.fromSnapshot(element));
            });
            
            return _tableBuilder(_items);
          }
          );

  }

  _tableBuilder(List<ItemPedido> items) {
    final List<Fila> filas = [];
    double total=0;
    int filasPorPag=3;
    items.forEach((element) {       
    Fila fila=Fila(celdas: <String>['${element.getImgUrl}','${element.getNombre}', '${element.getCantidad}', '\$${element.getPrecio}','\$${element.getPrecio*element.getCantidad}']);
    filas.add(fila);
    total=total+(element.getPrecio*element.getCantidad);
    });
        if(filas.length<filasPorPag){
      filasPorPag=filas.length;
    }
    return   
            Container(
            child: Column(
            children:[
            PaginatedDataTable(
            rowsPerPage: filasPorPag,
            columnSpacing: 5,
            columns: <DataColumn>[
              DataColumn(label: Text('Imagen')),
              DataColumn(label: Text('Especie')),
              DataColumn(label: Text('Número')),
              DataColumn(label: Text('Precio')),
              DataColumn(label: Text('Subtotal')),
            ],
            source: DataTableDataSourceP(context: context, filas: filas, imgWidth: 50)
            ),
            Tarjeta(
                    color:Colors.blueAccent,
                    contenido: 
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: 
                      Text(
                                  'Total: \$$total',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                    )
                    ),
            ]),
            );

  }
}