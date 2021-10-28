import 'package:acuarium/componentes/dialogo.dart';
import 'package:acuarium/componentes/tarjeta.dart';
import 'package:acuarium/modelo/data_table_data_source.dart';
import 'package:acuarium/modelo/fila.dart';
import 'package:acuarium/pantallas/cliente/informacion_pedido_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/listado_pedidos_cliente_pantalla.dart';
import 'package:acuarium/pantallas/cliente/pagina_principal_cliente_pantalla.dart';
import 'package:acuarium/pantallas/negocio/pagina_principal_negocio_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfirmacionPedidoClientePantalla extends StatelessWidget {
  static const String id = 'ConfirmacionPedidoClientePantalla';
  final List<Fila> filas = [
    Fila(celdas: <String>['Especie 1', '1', '\$150']),
    Fila(celdas: <String>['Especie 2', '1', '\$200']),
    Fila(celdas: <String>['Especie 3', '1', '\$150']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirmación de pedido'),),
      body: ListView(
        children: <Widget>[
          PaginatedDataTable(
            rowsPerPage: 3,
            columns: <DataColumn>[
              DataColumn(label: Text('Especie')),
              DataColumn(label: Text('Número')),
              DataColumn(label: Text('Subtotal')),
            ],
            source: DataTableDataSource(context: context, filas: filas)
          ),
          Tarjeta(
            color: Colors.white,
            contenido: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.mapMarkedAlt),
                  title: Text('Dirección'),
                  subtitle: Text('No ha seleccionado ninguna dirección'),
                ),
                TextButton(
                  child: Text('Seleccionar'),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.check),
        onPressed: () {
          Dialogo.dialogoProgreso(
            context,
            titulo: Text('Confirmación'),
            contenido: Text('Coloque su dedo en el lector de huellas digitales para confirmar el pedido'),
            future: Future.delayed(Duration(seconds: 10)),
            alTerminar: (valor) {
              Navigator.popUntil(context, ModalRoute.withName(PaginaPrincipalClientePantalla.id));
              Navigator.pushNamed(context, ListadoPedidosClientePantalla.id);
              Navigator.pushNamed(context, InformacionPedidoClientePantalla.id);
            },
            enError: (error) {}
          );
        },
      )
    );
  }
}